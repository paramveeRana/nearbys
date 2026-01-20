import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:nearbys/controller/sender_controller.dart';
import '../qr_scanner.dart';

class SquintEyeTest extends ConsumerStatefulWidget {
  const SquintEyeTest({super.key});

  @override
  ConsumerState<SquintEyeTest> createState() => _SquintEyeTestState();
}

class _SquintEyeTestState extends ConsumerState<SquintEyeTest> {
  final SenderController controller = SenderController();

  @override
  void initState() {
    super.initState();
    controller.initPermissions();
    controller.addListener(_refreshUI);
  }

  void _refreshUI() {
    if (mounted) setState(() {});
  }

  void openQrScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QrScanner(
          onScanned: (data) async {
            controller.setReceiverId(data);
            await Future.delayed(const Duration(milliseconds: 300));
            controller.startDiscovery();
          },
        ),
      ),
    );
  }

  void resetTest() async {
    await controller.resetFlow();
  }

  @override
  void dispose() {
    controller.disposeController();
    controller.removeListener(_refreshUI);
    super.dispose();
  }

  Widget _statusBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4F8BFF)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF4F8BFF)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              controller.userStatus,
              style: const TextStyle(
                color: Color(0xFF2C4DA8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _squintSlot() {
    Uint8List? imageBytes = controller.squintImageBytes;
    bool isLoading = controller.isCheckingSquint;

    return GestureDetector(
      onTap: () async {
        await controller.pickSquintImage(context, ref);
      },
      child: Container(
        height: 300,
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF4F8BFF),
            width: 1.5,
          ),
        ),
        child: DottedBorder(
          options: RectDottedBorderOptions(
            color: const Color(0xFF4F8BFF),
            strokeWidth: 1.5,
            dashPattern: const [8, 6],
            padding: const EdgeInsets.all(12),
          ),
          child: Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F8FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (imageBytes != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.memory(
                      imageBytes,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                if (imageBytes == null && !isLoading)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 90,
                        child: Lottie.asset(
                          'assets/animations/leftdata.json',
                          repeat: true,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        "Squint Eye",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "Take a clear photo of the squint eye",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF4F8BFF),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                if (isLoading) const CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionButton() {
    final bool qualityPassed = controller.squintImageId != null;

    if (controller.connectedEndpoint == null) {
      return SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: qualityPassed ? openQrScanner : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: qualityPassed
                ? const Color(0xFF4F8BFF)
                : Colors.grey.shade400,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "Connect Receiver",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: controller.sendSquintImage,
        icon: const Icon(Icons.send),
        label: const Text(
          "Send to Receiver",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4F8BFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _retestButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: resetTest,
        icon: const Icon(Icons.restart_alt, color: Color(0xFF4F8BFF)),
        label: const Text(
          "Retest",
          style: TextStyle(
            color: Color(0xFF4F8BFF),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF4F8BFF)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: _statusBanner(),
            ),

            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 4),
                  _squintSlot(),
                  const SizedBox(height: 28),
                  _actionButton(),
                  const SizedBox(height: 14),
                  _retestButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
