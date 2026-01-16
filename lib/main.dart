import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'sender_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nearbys/controller/vision_conroller.dart';

void main() {
  runApp(const ProviderScope(child: SenderApp()));
}

class SenderApp extends StatelessWidget {
  const SenderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SenderHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SenderHome extends ConsumerStatefulWidget {
  const SenderHome({super.key});

  @override
  ConsumerState<SenderHome> createState() => _SenderHomeState();
}

class _SenderHomeState extends ConsumerState<SenderHome> {
  final SenderController controller = SenderController();

  @override
  void initState() {
    super.initState();
    debugPrint("APP STARTED");
    controller.initPermissions();
    controller.addListener(_refreshUI);
  }

  void _refreshUI() {
    if (mounted) setState(() {});
  }

  void openQrScanner() {
    debugPrint("Opening QR scanner");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QrScanner(
          onScanned: (data) async {
            debugPrint("QR SCANNED: $data");
            controller.setReceiverId(data);
            await Future.delayed(const Duration(milliseconds: 300));
            controller.startDiscovery();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.disposeController();
    controller.removeListener(_refreshUI);
    super.dispose();
  }

  Widget _imageSlot(int index) {
    File? image = index == 0 ? controller.image0 : controller.image1;

    return GestureDetector(
      onTap: () async {
        try {
          await controller.pickImage(index, context);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to pick image"),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Container(
        width: 150,
        height: 180,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          borderRadius: BorderRadius.circular(12),
        ),
        child: image == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add_photo_alternate, size: 40),
            SizedBox(height: 10),
            Text("Tap to select"),
          ],
        )
            : ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(image, fit: BoxFit.cover),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sender App")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: controller.isDiscovering
                  ? controller.stopDiscovery
                  : openQrScanner,
              child: Text(
                controller.isDiscovering ? "Stop Discovery" : "Scan Receiver QR",
              ),
            ),

            const SizedBox(height: 20),
            Text("Status: ${controller.status}"),

            if (controller.sendProgress > 0 &&
                controller.sendProgress < 100) ...[
              const SizedBox(height: 10),
              LinearProgressIndicator(value: controller.sendProgress / 100),
              const SizedBox(height: 10),
              Text("${controller.sendProgress.toStringAsFixed(0)}%"),
            ],

            if (controller.connectedEndpoint != null) ...[
              const SizedBox(height: 30),
              const Text(
                "Send Images",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _imageSlot(0),
                  _imageSlot(1),
                ],
              ),

              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: controller.canSubmit
                    ? controller.sendBothImages
                    : null,
                child: const Text("Submit & Send Images"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class QrScanner extends StatefulWidget {
  final Function(String) onScanned;

  const QrScanner({super.key, required this.onScanned});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  final MobileScannerController controller = MobileScannerController();
  bool scanned = false;

  @override
  void dispose() {
    debugPrint("Disposing camera");
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Receiver QR")),
      body: MobileScanner(
        controller: controller,
        onDetect: (capture) async {
          if (scanned) return;

          final String? code = capture.barcodes.first.rawValue;
          if (code != null) {
            scanned = true;
            widget.onScanned(code);
            await Future.delayed(const Duration(milliseconds: 400));
            if (mounted) Navigator.pop(context);
          }
        },
      ),
    );
  }
}
