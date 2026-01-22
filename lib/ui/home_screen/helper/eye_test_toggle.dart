import 'package:flutter/material.dart';
import 'package:sccore_sync/ui/utils/app_enums.dart';
import 'package:sccore_sync/ui/utils/theme/app_colors.dart';
import 'package:sccore_sync/ui/utils/theme/text_styles.dart';
import 'package:sccore_sync/ui/utils/widgets/common_text.dart';

class EyeTestToggle extends StatelessWidget {
  final EyeTestType selected;
  final Function(EyeTestType) onChanged;

  const EyeTestToggle({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.clr009AF1,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: selected == EyeTestType.cataract
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              width: 126,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(26),
              ),
            ),
          ),
          Row(
            children: [
              _buildTab("Cataract", EyeTestType.cataract),
              _buildTab("Squint", EyeTestType.squint),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTab(String title, EyeTestType type) {
    final bool isSelected = selected == type;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(type),
        child: SizedBox(
          height: double.infinity,
          child: Center(
            child: CommonText(
              title: title,
              style: TextStyles.regular.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.clr009AF1 : AppColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
