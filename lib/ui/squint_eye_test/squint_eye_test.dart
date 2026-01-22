import 'dart:typed_data';
import 'dart:ui' as BorderType;
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:sccore_sync/framework/controller/sender_controller.dart';
import 'package:sccore_sync/ui/utils/theme/app_colors.dart';
import 'package:sccore_sync/ui/utils/theme/text_styles.dart';
import 'package:sccore_sync/ui/utils/widgets/common_text.dart';
import '../utils/widgets/qr_scanner.dart';

class SquintEyeTest extends ConsumerStatefulWidget {
  const SquintEyeTest({super.key});

  @override
  ConsumerState<SquintEyeTest> createState() => _SquintEyeTestState();
}

class _SquintEyeTestState extends ConsumerState<SquintEyeTest> {

  void openQrScanner(SenderController controller) {
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

  void resetTest(SenderController controller) async {
    await controller.resetFlow();
  }

  Widget _statusBanner(SenderController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.clrF0F5FF,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.clr009AF1),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.clr009AF1),
          const SizedBox(width: 10),
          Expanded(
            child: CommonText(
              title: controller.userStatus,
              style: TextStyles.medium.copyWith(
                color: AppColors.clr2C4DA8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _squintSlot(SenderController controller) {
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
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.clr009AF1,
            width: 1.5,
          ),
        ),
        child: DottedBorder(
          options: RectDottedBorderOptions(
            color: AppColors.clr009AF1,
            strokeWidth: 1.5,
            dashPattern: const [8, 6],
            padding: const EdgeInsets.all(12),
          ),
          child: Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              color: AppColors.clrF5F8FF,
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
                      CommonText(
                        title: "Squint Eye",
                        style: TextStyles.bold.copyWith(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: CommonText(
                          title: "Take a clear photo of the squint eye",
                          textAlign: TextAlign.center,
                          style: TextStyles.medium.copyWith(
                            color: AppColors.clr009AF1,
                            fontSize: 14,
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

  Widget _actionButton(SenderController controller) {
    final bool qualityPassed = controller.squintImageId != null;

    if (controller.isDiscovering ||
        controller.isConnecting ||
        controller.isSending) {
      return _loaderButton();
    }

    if (controller.connectedEndpoint == null) {
      return SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: qualityPassed ? () => openQrScanner(controller) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: qualityPassed
                ? AppColors.clr009AF1
                : Colors.grey.shade400,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: CommonText(
            title: "Connect Receiver",
            style: TextStyles.semiBold.copyWith(fontSize: 16, color: Colors.white),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: controller.sendSquintImage,
        label: CommonText(
          title: "Send to Receiver",
          style: TextStyles.semiBold.copyWith(fontSize: 16,color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.clr009AF1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
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
          backgroundColor: AppColors.clr009AF1,
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

  Widget _uploadProgressBar(SenderController controller) {
    if (controller.sendProgress <= 0 || controller.sendProgress >= 100) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            title: "Uploading... ${controller.sendProgress.toStringAsFixed(0)}%",
            style: TextStyles.semiBold.copyWith(
              fontSize: 14,
              color: AppColors.clr009AF1,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: controller.sendProgress / 100,
              backgroundColor: Colors.grey.shade300,
              color: AppColors.clr009AF1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _retestButton(SenderController controller) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: () => resetTest(controller),
        icon: const Icon(Icons.restart_alt, color: AppColors.clr009AF1),
        label: CommonText(
          title: "Retest",
          style: TextStyles.semiBold.copyWith(
            color: AppColors.clr009AF1,
            fontSize: 15,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.clr009AF1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(senderControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: _statusBanner(controller),
            ),

            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 4),
                  _squintSlot(controller),
                  const SizedBox(height: 28),
                  _uploadProgressBar(controller),
                  const SizedBox(height: 6),
                  _actionButton(controller),
                  const SizedBox(height: 14),
                  _retestButton(controller),
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
