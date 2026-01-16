import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class SenderController extends ChangeNotifier {
  bool isDiscovering = false;
  bool isConnecting = false;

  int? sendingPayloadId;
  double sendProgress = 0;

  File? image0; // left eye
  File? image1; // right eye

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

  Future<void> pickImage(int index, BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) return;

    final file = File(result.files.single.path!);

    if (index == 0) {
      image0 = file;
    } else {
      image1 = file;
    }

    notifyListeners();
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
      final imageBytes = await file.readAsBytes();

      final payload = Uint8List(imageBytes.length + 1);
      payload[0] = imageId;
      payload.setRange(1, payload.length, imageBytes);

      await nearby.sendBytesPayload(
        connectedEndpoint!,
        payload,
      );

      status = "Sending image...";
      sendProgress = 0;
      notifyListeners();
    } catch (e) {}
  }

  void disposeController() {
    stopDiscovery();
  }
}
