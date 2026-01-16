import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
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
    debugPrint("Disposing QR camera");
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

            debugPrint("QR DETECTED: $code");
            widget.onScanned(code);

            // Let camera shut down properly
            await Future.delayed(const Duration(milliseconds: 300));

            if (mounted) {
              Navigator.pop(context);
            }
          }
        },
      ),
    );
  }
}
