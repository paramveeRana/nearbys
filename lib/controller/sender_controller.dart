import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image/image.dart' as img;
import 'package:nearby_connections/nearby_connections.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'enums.dart';
import 'vision_conroller.dart';

final senderControllerProvider = ChangeNotifierProvider((ref) => SenderController());

class SenderController extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  bool isDiscovering = false;
  bool isConnecting = false;

  int? sendingPayloadId;
  double sendProgress = 0;

  Uint8List? imageBytes0;
  Uint8List? imageBytes1;

  bool isSquintFlow = false;

  File? image0; // left eye
  File? image1; // right eye

  static const int LEFT_EYE = 0;
  static const int RIGHT_EYE = 1;

  String? leftImageId;
  String? rightImageId;

  /// squint eye test
  Uint8List? squintImageBytes;
  File? squintImage;
  String? squintImageId;
  bool isCheckingSquint = false;

  Map<String, dynamic>? squintResultJson;


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
        maxWidth: 720,
        maxHeight: 720,
      );

      if (photo == null) return;

      final Uint8List rawBytes = await photo.readAsBytes();

      // normalize image for API
      final decoded = img.decodeImage(rawBytes);
      if (decoded == null) return;

      final Uint8List jpegBytes =
      Uint8List.fromList(img.encodeJpg(decoded, quality: 90));

      // show instantly from RAM
      if (index == LEFT_EYE) {
        imageBytes0 = jpegBytes;
        isChecking0 = true;
      } else {
        imageBytes1 = jpegBytes;
        isChecking1 = true;
      }
      notifyListeners();

      // save normalized file for sending later
      final tempDir = Directory.systemTemp;
      final file = File(
          '${tempDir.path}/eye_${index}_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await file.writeAsBytes(jpegBytes);

      if (index == LEFT_EYE) {
        image0 = file;
      } else {
        image1 = file;
      }

      // API call with normalized JPEG
      final vision = ref.read(visionController);

      final bool isPassed = await vision.captureAiVisionTestImage(
        context,
        index == LEFT_EYE
            ? AiVisionTestImageTypeEnum.leftEye
            : AiVisionTestImageTypeEnum.rightEye,
        ref,
        jpegBytes,
      );

      if (isPassed) {
        if (index == LEFT_EYE) {
          leftImageId = vision.leftEyeId;
        } else {
          rightImageId = vision.rightEyeId;
        }
      } else {
        if (index == LEFT_EYE) {
          imageBytes0 = null;
          image0 = null;
        } else {
          imageBytes1 = null;
          image1 = null;
        }
      }

      if (index == LEFT_EYE) isChecking0 = false;
      if (index == RIGHT_EYE) isChecking1 = false;

      notifyListeners();
    } catch (e) {
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
      // Read original bytes
      final Uint8List originalBytes = await file.readAsBytes();

      // Decode image
      final img.Image? decoded = img.decodeImage(originalBytes);
      if (decoded == null) {
        debugPrint("Failed to decode image for compression");
        return;
      }

      // Resize for faster transfer (keeps good quality for eyes)
      final img.Image resized = img.copyResize(
        decoded,
        width: 720, // tune: 640 (faster) | 800 (better quality)
      );

      // Encode JPEG with balanced quality
      final Uint8List compressedBytes =
          Uint8List.fromList(img.encodeJpg(resized, quality: 65));

      debugPrint(
          "Original size: ${originalBytes.lengthInBytes ~/ 1024} KB");
      debugPrint(
          "Compressed size: ${compressedBytes.lengthInBytes ~/ 1024} KB");

      // Get correct imageId
      final String imgId =
          eyeIndex == LEFT_EYE ? (leftImageId ?? "") : (rightImageId ?? "");

      if (imgId.isEmpty) {
        debugPrint("ImageId missing. Not sending payload.");
        return;
      }

      debugPrint(
          "Sending image. Eye: ${eyeIndex == LEFT_EYE ? "LEFT" : "RIGHT"}, ImageId: $imgId");

      final Uint8List idBytes = Uint8List.fromList(imgId.codeUnits);

      // Payload format:
      // [eyeSide][imageIdLength][imageIdBytes...][imageBytes...]
      final Uint8List payload =
          Uint8List(2 + idBytes.length + compressedBytes.length);

      payload[0] = eyeIndex; // 0 = left, 1 = right
      payload[1] = idBytes.length; // imageId length
      payload.setRange(2, 2 + idBytes.length, idBytes);
      payload.setRange(
          2 + idBytes.length, payload.length, compressedBytes);

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
      await stopDiscovery();

      if (connectedEndpoint != null) {
        try {
          await nearby.disconnectFromEndpoint(connectedEndpoint!);
        } catch (_) {}
      }

      connectedEndpoint = null;
      receiverId = "";
      status = "Idle";

      image0 = null;
      image1 = null;

      imageBytes0 = null;
      imageBytes1 = null;

      leftImageId = null;
      rightImageId = null;

      // reset squint
      squintImage = null;
      squintImageBytes = null;
      squintImageId = null;
      isCheckingSquint = false;
      squintResultJson = null;

      isChecking0 = false;
      isChecking1 = false;

      sendProgress = 0;
      sendingPayloadId = null;

      notifyListeners();
    } catch (e) {
      debugPrint("Reset flow error: $e");
    }
  }

  /// squint image pick
  Future<void> pickSquintImage(BuildContext context, WidgetRef ref) async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 90,
        maxWidth: 720,
        maxHeight: 720,
      );

      if (photo == null) return;

      final Uint8List rawBytes = await photo.readAsBytes();

      final decoded = img.decodeImage(rawBytes);
      if (decoded == null) return;

      final Uint8List jpegBytes =
      Uint8List.fromList(img.encodeJpg(decoded, quality: 90));

      squintImageBytes = jpegBytes;
      isCheckingSquint = true;
      notifyListeners();

      final tempDir = Directory.systemTemp;
      final file =
      File('${tempDir.path}/squint_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await file.writeAsBytes(jpegBytes);

      squintImage = file;

      final vision = ref.read(visionController);
      final bool isPassed =
      await vision.captureAiSquintTestImage(context, ref, jpegBytes);

      if (isPassed) {
        squintImageId = vision.squintEyeId;
        squintResultJson = vision.squintScanState.success!.toJson();
      } else {
        squintImageBytes = null;
        squintImage = null;
      }

      isCheckingSquint = false;
      notifyListeners();
    } catch (e) {
      debugPrint("Squint capture failed: $e");
    }
  }

  /// send squint image
  Future<void> sendSquintImage() async {
    if (connectedEndpoint == null ||
        squintImage == null ||
        squintResultJson == null ||
        squintImageId == null) return;

    try {
      // Read image
      final Uint8List originalBytes = await squintImage!.readAsBytes();

      final img.Image? decoded = img.decodeImage(originalBytes);
      if (decoded == null) return;

      final img.Image resized = img.copyResize(decoded, width: 720);

      final Uint8List compressedBytes =
      Uint8List.fromList(img.encodeJpg(resized, quality: 65));

      // Encode JSON result
      final Uint8List jsonBytes =
      Uint8List.fromList(utf8.encode(jsonEncode(squintResultJson)));

      // Encode Image ID
      final Uint8List idBytes =
      Uint8List.fromList(squintImageId!.codeUnits);

      final int jsonLength = jsonBytes.length;
      final int idLength = idBytes.length;

      // Payload format:
      // [type][idLength][idBytes][jsonLength(2)][json][image]
      final Uint8List payload = Uint8List(
        1 + 1 + idBytes.length + 2 + jsonBytes.length + compressedBytes.length,
      );

      int offset = 0;

      payload[offset++] = 2; // type = squint
      payload[offset++] = idLength;

      payload.setRange(offset, offset + idBytes.length, idBytes);
      offset += idBytes.length;

      payload[offset++] = (jsonLength >> 8) & 0xFF;
      payload[offset++] = jsonLength & 0xFF;

      payload.setRange(offset, offset + jsonBytes.length, jsonBytes);
      offset += jsonBytes.length;

      payload.setRange(offset, offset + compressedBytes.length, compressedBytes);

      debugPrint("Sending squint image + result + ID");
      debugPrint("Squint Image ID: $squintImageId");
      debugPrint("Squint JSON Length: $jsonLength");
      debugPrint("Squint Image Size: ${compressedBytes.lengthInBytes ~/ 1024} KB");

      await nearby.sendBytesPayload(connectedEndpoint!, payload);

      status = "Sending squint image...";
      sendProgress = 0;
      notifyListeners();
    } catch (e) {
      debugPrint("Squint send error: $e");
    }
  }



  void disposeController() {
    stopDiscovery();
  }

  /// status
  String get userStatus {
    if (squintImageId != null && connectedEndpoint == null) {
      return "Squint image verified. Please connect to the receiver device.";
    }

    if (connectedEndpoint != null && squintImageId != null && sendProgress == 0) {
      return "Connected. Ready to send squint image.";
    }

    if (sendProgress > 0 && sendProgress < 100 && squintImageId != null) {
      return "Uploading squint image... ${sendProgress.toStringAsFixed(0)}%";
    }

    if (sendProgress == 100 && squintImageId != null) {
      return "Squint test completed successfully.";
    }

    if (isDiscovering && !isConnecting) {
      return "Searching for receiver device...";
    }

    if (isConnecting) {
      return "Connecting to receiver device...";
    }

    if (connectedEndpoint != null && !canSubmit && squintImageId == null) {
      return "Device connected. Please capture both eye images.";
    }

    if (leftImageId != null && rightImageId != null && connectedEndpoint == null) {
      return "Eye images verified. Please connect to the receiver device.";
    }

    if (canSubmit && sendProgress == 0) {
      return "Connected. Ready to send images.";
    }

    if (sendProgress > 0 && sendProgress < 100) {
      return "Uploading images... ${sendProgress.toStringAsFixed(0)}%";
    }

    if (sendProgress == 100) {
      return "Test completed successfully.";
    }

    return "Please capture image to start the test.";
  }




}