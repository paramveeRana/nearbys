import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:nearby_connections/nearby_connections.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'controller/enums.dart';
import 'controller/vision_conroller.dart';

class SenderController extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  bool isDiscovering = false;
  bool isConnecting = false;

  int? sendingPayloadId;
  double sendProgress = 0;

  File? image0; // left eye
  File? image1; // right eye

  static const int LEFT_EYE = 0;
  static const int RIGHT_EYE = 1;

  String? leftImageId;
  String? rightImageId;

  bool isChecking0 = false; // left eye loading
  bool isChecking1 = false; // right eye loading

  final Nearby nearby = Nearby();
  final Strategy strategy = Strategy.P2P_POINT_TO_POINT;

  String receiverId = "";
  String status = "Idle";
  String? connectedEndpoint;

  static const String serviceId = "com.example.nearbyshare";

  bool get canSubmit =>
      image0 != null && image1 != null && connectedEndpoint != null;

  Future<void> initPermissions() async {
    await Permission.camera.request();
    await Permission.location.request();
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.nearbyWifiDevices.request();
    await Permission.locationWhenInUse.request();
    await Permission.storage.request();
  }

  void setReceiverId(String id) {
    receiverId = id;
  }

  Future<void> startDiscovery() async {
    await stopDiscovery();

    status = "Starting discovery...";
    notifyListeners();

    try {
      isDiscovering = true;
      isConnecting = false;

      await nearby.startDiscovery(
        "SENDER_DEVICE",
        strategy,
        serviceId: serviceId,
        onEndpointFound: (id, name, foundServiceId) {
          if (name != receiverId) return;
          if (connectedEndpoint != null) return;
          if (isConnecting) return;

          isConnecting = true;
          status = "Receiver found. Connecting...";
          notifyListeners();

          stopDiscovery();

          nearby.requestConnection(
            "SENDER_DEVICE",
            id,
            onConnectionInitiated: (endpointId, info) {
              nearby.acceptConnection(
                endpointId,
                onPayLoadRecieved: (endid, payload) {},
                onPayloadTransferUpdate: (endpointId, update) {
                  sendingPayloadId ??= update.id;

                  if (update.id != sendingPayloadId) return;

                  if (update.totalBytes > 0) {
                    final percent =
                        (update.bytesTransferred / update.totalBytes) * 100;

                    sendProgress = percent;
                    status = "Sending... ${percent.toStringAsFixed(0)}%";
                    notifyListeners();
                  }

                  if (update.status == PayloadStatus.SUCCESS) {
                    sendProgress = 100;
                    status = "Image sent successfully";
                    notifyListeners();
                  }
                },
              );
            },
            onConnectionResult: (endpointId, connectionStatus) {
              if (connectionStatus == Status.CONNECTED) {
                connectedEndpoint = endpointId;
                isConnecting = false;
                status = "Connected. Select images.";
                notifyListeners();
              } else {
                isConnecting = false;
              }
            },
            onDisconnected: (endpointId) {
              connectedEndpoint = null;
              isConnecting = false;
              status = "Disconnected";
              notifyListeners();
            },
          );
        },
        onEndpointLost: (id) {},
      );

      status = "Scanning for receiver...";
      notifyListeners();
    } catch (e) {
      isDiscovering = false;
      status = "Discovery failed";
      notifyListeners();
    }
  }

  Future<void> stopDiscovery() async {
    if (!isDiscovering) return;

    try {
      await nearby.stopDiscovery();
    } catch (e) {}

    isDiscovering = false;
    status = "Discovery stopped";
    notifyListeners();
  }

  Future<void> pickImage(int index, BuildContext context, WidgetRef ref) async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 90,
      );

      if (photo == null) return;

      final file = File(photo.path);

      if (!await file.exists()) {
        debugPrint("Captured image file does not exist");
        return;
      }

      // Read raw bytes (Lenovo back camera may return HEIC/rotated image)
      final rawBytes = await file.readAsBytes();

      // Decode any format safely
      final decoded = img.decodeImage(rawBytes);
      if (decoded == null) {
        debugPrint("Failed to decode image");
        return;
      }

      // Re-encode as clean JPEG so Flutter can render it
      final jpegBytes = img.encodeJpg(decoded, quality: 90);

      // Overwrite file with normalized JPEG
      final normalizedFile = await file.writeAsBytes(jpegBytes);

      // Show image immediately
      if (index == 0) {
        image0 = normalizedFile;
        isChecking0 = true;
      } else {
        image1 = normalizedFile;
        isChecking1 = true;
      }
      notifyListeners();

      // Convert image to bytes
      final Uint8List bytes = jpegBytes;

      // Call quality check API
      final vision = ref.read(visionController);

      final bool isPassed = await vision.captureAiVisionTestImage(
        context,
        index == 0
            ? AiVisionTestImageTypeEnum.leftEye
            : AiVisionTestImageTypeEnum.rightEye,
        ref,
        bytes,
      );

      if (isPassed) {
        if (index == 0) {
          leftImageId = vision.leftEyeId;
        } else {
          rightImageId = vision.rightEyeId;
        }
      }

      // Stop loading
      if (index == 0) {
        isChecking0 = false;
      } else {
        isChecking1 = false;
      }

      // If quality failed → remove image
      if (!isPassed) {
        if (index == 0) {
          image0 = null;
          leftImageId = null;
        } else {
          image1 = null;
          rightImageId = null;
        }
      }

      notifyListeners();
    } catch (e) {
      if (index == 0) {
        isChecking0 = false;
        image0 = null;
      } else {
        isChecking1 = false;
        image1 = null;
      }
      notifyListeners();
      debugPrint("Camera capture failed: $e");
    }
  }
  Future<void> sendBothImages() async {
    if (!canSubmit) return;

    await Future.delayed(const Duration(milliseconds: 600));
    await _sendImage(image0!, LEFT_EYE);

    await Future.delayed(const Duration(milliseconds: 800));
    await _sendImage(image1!, RIGHT_EYE);
  }

  // ---------------- SEND IMAGE PAYLOAD ----------------

  Future<void> _sendImage(File file, int eyeIndex) async {
    if (connectedEndpoint == null) return;

    try {
      // Read raw image bytes (no decoding, no re-encoding)
      final Uint8List imageBytes = await file.readAsBytes();

      // Get correct imageId
      final String imgId =
          eyeIndex == LEFT_EYE ? (leftImageId ?? "") : (rightImageId ?? "");

      if (imgId.isEmpty) {
        debugPrint("ImageId missing. Not sending payload.");
        return;
      }

      debugPrint(
          "Sending image to receiver. Eye: ${eyeIndex == LEFT_EYE ? "LEFT" : "RIGHT"}, ImageId: $imgId");

      final Uint8List idBytes = Uint8List.fromList(imgId.codeUnits);

      // Payload format:
      // [eyeSide][imageIdLength][imageIdBytes...][imageBytes...]
      final Uint8List payload =
          Uint8List(2 + idBytes.length + imageBytes.length);

      payload[0] = eyeIndex; // 0 = left, 1 = right
      payload[1] = idBytes.length; // imageId length
      payload.setRange(2, 2 + idBytes.length, idBytes);
      payload.setRange(2 + idBytes.length, payload.length, imageBytes);

      await nearby.sendBytesPayload(connectedEndpoint!, payload);

      status = "Sending image...";
      sendProgress = 0;
      notifyListeners();
    } catch (e) {
      debugPrint("Send error: $e");
    }
  }
  /// reset flow
  Future<void> resetFlow() async {
    try {
      // Stop discovery
      await stopDiscovery();

      // Disconnect receiver if connected
      if (connectedEndpoint != null) {
        try {
          await nearby.disconnectFromEndpoint(connectedEndpoint!);
        } catch (_) {}
      }

      // Reset connection state
      connectedEndpoint = null;
      receiverId = "";
      status = "Idle";

      // Reset images
      image0 = null;
      image1 = null;
      leftImageId = null;
      rightImageId = null;

      // Reset loading flags
      isChecking0 = false;
      isChecking1 = false;

      // Reset progress
      sendProgress = 0;
      sendingPayloadId = null;

      notifyListeners();
    } catch (e) {
      debugPrint("Reset flow error: $e");
    }
  }
  void disposeController() {
    stopDiscovery();
  }
}
