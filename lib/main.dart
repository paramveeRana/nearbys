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
    bool isLoading = index == 0 ? controller.isChecking0 : controller.isChecking1;

    return GestureDetector(
      onTap: () async {
        try {
          await controller.pickImage(index, context, ref);
        } catch (e) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              Future.delayed(const Duration(seconds: 3), () {
                if (Navigator.canPop(context)) Navigator.pop(context);
              });
              return AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: const Text("Result"),
                content: Text(e.toString()),
              );
            },
          );
        }
      },
      child: Container(
        width: double.infinity,
        height: 300,
        decoration: BoxDecoration(
          color: const Color(0xFFEAF3FF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFB7D3FF), width: 1.2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: image == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.camera_alt_outlined, size: 48, color: Color(0xFF4F8BFF)),
                  const SizedBox(height: 10),
                  Text(
                    index == 0 ? "Left Eye" : "Right Eye",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF2C5BFF)),
                  ),
                ],
              )
            : Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(image, fit: BoxFit.fill),
                    ),
                  ),
                  if (isLoading)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Eye Vision Test"),
        backgroundColor: const Color(0xFF4F8BFF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF3F8FF),
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              children: [
              const SizedBox(height: 5),
              Text(
                "Capture Both Eye Images",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF1F3C88)),
              ),

              const SizedBox(height: 5),

              Column(
                children: const [],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: _imageSlot(0),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: _imageSlot(1),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              const Divider(),

              const SizedBox(height: 15),

              Text(
                "Connect to Receiver",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF1F3C88)),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (controller.image0 != null &&
                              controller.image1 != null &&
                              !controller.isChecking0 &&
                              !controller.isChecking1)
                      ? () async {
                    // If already connected → reset flow
                    if (controller.connectedEndpoint != null) {
                      await controller.resetFlow();
                      return;
                    }

                    // Normal scan flow
                    if (controller.isDiscovering) {
                      await controller.stopDiscovery();
                    } else {
                      openQrScanner();
                    }
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F8BFF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    controller.connectedEndpoint != null
                        ? "Rescan Receiver QR"
                        : controller.isDiscovering
                        ? "Stop Discovery"
                        : "Scan Receiver QR",
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF3FF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFB7D3FF), width: 1.2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Color(0xFF4F8BFF)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        controller.status,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1F3C88)),
                      ),
                    ),
                  ],
                ),
              ),

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
                  "Connected. Ready to Send",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF1F3C88)),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.canSubmit
                        ? controller.sendBothImages
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F8BFF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text("Submit & Send Images"),
                  ),
                ),
              ],
            ]),
          ),
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Scan Receiver QR"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          MobileScanner(
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

          // Scanner overlay
          Positioned.fill(
            child: Column(
              children: [
                const SizedBox(height: 30),
                const Text(
                  "Align the QR code within the frame",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const Spacer(),
                Center(
                  child: Container(
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    "Scanning for receiver QR...",
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
