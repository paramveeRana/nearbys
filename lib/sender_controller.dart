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

      // Show image immediately
      if (index == 0) {
        image0 = file;
        isChecking0 = true;
      } else {
        image1 = file;
        isChecking1 = true;
      }
      notifyListeners();

      // Convert image to bytes
      final Uint8List bytes = await file.readAsBytes();

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
        } else {
          image1 = null;
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
    await _sendImage(image0!, 0);

    await Future.delayed(const Duration(milliseconds: 800));
    await _sendImage(image1!, 1);
  }


  Future<void> _sendImage(File file, int imageId) async {
    if (connectedEndpoint == null) return;

    try {
      final rawBytes = await file.readAsBytes();

      // Decode any format (HEIC/JPEG/PNG)
      final decoded = img.decodeImage(rawBytes);
      if (decoded == null) {
        debugPrint("Failed to decode image");
        return;
      }

      // Re-encode as pure JPEG
      final jpegBytes = img.encodeJpg(decoded, quality: 90);

      final payload = Uint8List(jpegBytes.length + 1);
      payload[0] = imageId;
      payload.setRange(1, payload.length, jpegBytes);

      await nearby.sendBytesPayload(connectedEndpoint!, payload);

      status = "Sending image...";
      sendProgress = 0;
      notifyListeners();
    } catch (e) {
      debugPrint("Send error: $e");
    }
  }
  void disposeController() {
    stopDiscovery();
  }
}
