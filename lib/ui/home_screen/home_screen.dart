import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nearbys/controller/sender_controller.dart';
import 'package:nearbys/ui/cataract_eye_test/cataract_eye_test.dart';
import 'package:nearbys/ui/squint_eye_test/squint_eye_test.dart';
import 'package:nearbys/ui/utils/app_enums.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Sccore Sync",style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xff009AF1),
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
