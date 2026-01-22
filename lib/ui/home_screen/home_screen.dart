import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sccore_sync/framework/controller/sender_controller.dart';
import 'package:sccore_sync/ui/cataract_eye_test/cataract_eye_test.dart';
import 'package:sccore_sync/ui/squint_eye_test/squint_eye_test.dart';
import 'package:sccore_sync/ui/utils/app_enums.dart';
import 'package:sccore_sync/ui/utils/theme/app_colors.dart';
import 'package:sccore_sync/ui/utils/widgets/common_text.dart';

import 'helper/eye_test_toggle.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  EyeTestType selectedTest = EyeTestType.cataract;

  @override
  Widget build(BuildContext context) {
    final senderController = ref.read(senderControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const CommonText(title:"Sccore Sync",style: TextStyle(color: AppColors.white),),
        backgroundColor: AppColors.clr009AF1,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            EyeTestToggle(
              selected: selectedTest,
              onChanged: (type) async {
                await senderController.resetConnectionHard();

                senderController.isSquintFlow = type == EyeTestType.squint;

                setState(() => selectedTest = type);
              },
            ),

            const SizedBox(height: 24),

            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: selectedTest == EyeTestType.cataract
                    ? const CataractEyeTest()
                    : const SquintEyeTest(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
