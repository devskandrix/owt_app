import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A pill-shaped toggle switch matching the Settings screen's Figma
/// component (43x25 track, white thumb, solid purple "on" fill). The "off"
/// track color isn't shown in Figma (every reference switch is "on"), so it
/// falls back to a neutral iOS-style gray that flips with theme.
class AppSwitch extends StatelessWidget {
  const AppSwitch({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final offColor = isDark ? const Color(0xFF3A3A3C) : const Color(0xFFE9E9EB);
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 43,
        height: 25,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: value ? AppColors.toggleOn : offColor,
          borderRadius: BorderRadius.circular(13),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 150),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 17,
            height: 17,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
