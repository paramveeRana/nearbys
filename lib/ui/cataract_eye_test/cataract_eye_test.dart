import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:nearbys/framework/controller/sender_controller.dart';
import 'package:nearbys/ui/utils/theme/app_colors.dart';
import 'package:nearbys/ui/utils/theme/text_styles.dart';
import 'package:nearbys/ui/utils/widgets/common_text.dart';
import 'package:nearbys/ui/utils/widgets/qr_scanner.dart';

class CataractEyeTest extends ConsumerStatefulWidget {
  const CataractEyeTest({super.key});

  @override
  ConsumerState<CataractEyeTest> createState() => _CataractEyeTestState();
}

class _CataractEyeTestState extends ConsumerState<CataractEyeTest> {

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
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageSlot(int index, SenderController controller) {
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
                          index == 0
                              ? 'assets/animations/leftdata.json'
                              : 'assets/animations/rightdata.json',
                          repeat: true,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 2),
                      CommonText(
                        title: index == 0 ? "Left Eye" : "Right Eye",
                        style: TextStyles.bold.copyWith(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                        child: CommonText(
                          title: index == 0
                              ? "Take a clear photo of your left eye"
                              : "Take a clear photo of your right eye",
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

  Widget _actionButton(SenderController controller) {
    final bool qualityPassed =
        controller.leftImageId != null && controller.rightImageId != null;

    // SHOW LOADER WHILE DISCOVERING, CONNECTING OR SENDING
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
          onPressed: qualityPassed
              ? () => openQrScanner(controller)
              : null,
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
          child: CommonText(
            title: "Capture both eye images",
            style: TextStyles.semiBold.copyWith(fontSize: 16,),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: controller.sendBothImages,
        icon: const Icon(Icons.send),
        label: CommonText(
          title: "Send to Receiver",
          style: TextStyles.semiBold.copyWith(fontSize: 16, color: Colors.white),
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
            fontWeight: FontWeight.w600,
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _statusBanner(controller),
          const SizedBox(height: 20),
          _imageSlot(0, controller),
          const SizedBox(height: 20),
          _imageSlot(1, controller),
          const SizedBox(height: 28),
          _actionButton(controller),
          const SizedBox(height: 14),
          _retestButton(controller),
        ],
      ),
    );
  }
}
