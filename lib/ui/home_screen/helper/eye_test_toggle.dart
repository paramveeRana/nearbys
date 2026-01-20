import 'package:flutter/material.dart';
import 'package:nearbys/ui/utils/app_enums.dart';

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
        color: const Color(0xFF4F8BFF),
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
                color: Colors.white,
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
        onTap: () => onChanged(type),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isSelected ? const Color(0xFF4F8BFF) : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
