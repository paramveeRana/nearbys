import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:nearbys/controller/sender_controller.dart';
import '../qr_scanner.dart';

class CataractEyeTest extends ConsumerStatefulWidget {
  const CataractEyeTest({super.key});

  @override
  ConsumerState<CataractEyeTest> createState() => _ContractEyeTestState();
}

class _ContractEyeTestState extends ConsumerState<CataractEyeTest> {
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
        border: Border.all(color: const Color(0xff009AF1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xff009AF1)),
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

  Widget _imageSlot(int index) {
    Uint8List? imageBytes =
    index == 0 ? controller.imageBytes0 : controller.imageBytes1;

    bool isLoading =
    index == 0 ? controller.isChecking0 : controller.isChecking1;

    return GestureDetector(
      onTap: () async {
        await controller.pickImage(index, context, ref);
      },
      child: Container(
        height: 300,
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xff009AF1),
            width: 1.5,
          ),
        ),
        child: DottedBorder(
          options: RectDottedBorderOptions(
            color: const Color(0xff009AF1),
            strokeWidth: 1.5,
            dashPattern: const [8, 6],
            // borderType: BorderType.RRect,
            // radius: const Radius.circular(16),
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
                          index == 0
                              ? 'assets/animations/leftdata.json'
                              : 'assets/animations/rightdata.json',
                          repeat: true,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        index == 0 ? "Left Eye" : "Right Eye",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                        child: Text(
                          index == 0
                              ? "Take a clear photo of your left eye"
                              : "Take a clear photo of your right eye",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xff009AF1),
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

  Widget _loaderButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff009AF1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: LoadingAnimationWidget.waveDots(
          color: Colors.white,
          size: 40,
        ),
      ),
    );
  }


  Widget _actionButton() {
    final bool qualityPassed =
        controller.leftImageId != null && controller.rightImageId != null;

    // SHOW LOADER WHILE CONNECTING
    if (controller.isConnecting) {
      return _loaderButton();
    }

    // NOT CONNECTED
    if (controller.connectedEndpoint == null) {
      return SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: qualityPassed ? openQrScanner : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: qualityPassed
                ? const Color(0xff009AF1)
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

    // CONNECTED BUT IMAGES MISSING
    if (!controller.canSubmit) {
      return SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade400,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "Capture both eye images",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      );
    }

    // READY TO SEND
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: controller.sendBothImages,
        icon: const Icon(Icons.send),
        label: const Text(
          "Send to Receiver",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff009AF1),
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
        icon: const Icon(Icons.restart_alt, color: Color(0xff009AF1)),
        label: const Text(
          "Retest",
          style: TextStyle(
            color: Color(0xff009AF1),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xff009AF1)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _statusBanner(),
          const SizedBox(height: 20),
          _imageSlot(0),
          const SizedBox(height: 20),
          _imageSlot(1),
          const SizedBox(height: 28),
          _actionButton(),
          const SizedBox(height: 14),
          _retestButton(),
        ],
      ),
    );
  }
}
