import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sccore_sync/ui/utils/theme/app_colors.dart';

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
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Scan Receiver QR"),
        backgroundColor: AppColors.clr009AF1,
      ),
      body: Stack(
        children: [
          /// Camera View
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

          /// Dark Overlay
          Container(
            color: Colors.black.withOpacity(0.01),
          ),

          /// Scanner Frame
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          /// Cut-out Effect
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          /// Instruction
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: const [
                Icon(Icons.qr_code_scanner, color: Colors.white, size: 36),
                SizedBox(height: 12),
                Text(
                  "Align receiver QR inside the frame",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
