import 'package:flutter/material.dart';
import 'package:nearbys/ui/cataract_eye_test/cataract_eye_test.dart';
import 'package:nearbys/ui/squint_eye_test/squint_eye_test.dart';
import 'package:nearbys/ui/utils/app_enums.dart';

import 'helper/eye_test_toggle.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  EyeTestType selectedTest = EyeTestType.cataract;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("AI Vision Test"),
        backgroundColor: const Color(0xFF4F8BFF),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            EyeTestToggle(
              selected: selectedTest,
              onChanged: (type) {
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
