import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A field label above a pill-shaped input with a leading icon, matching
/// the "Full Name" / "Date of Birth" fields on the Create Account screen.
class LabeledTextField extends StatelessWidget {
  const LabeledTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.iconAsset,
    required this.controller,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
  });

  final String label;
  final String hintText;
  final String iconAsset;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.fieldLabel.copyWith(color: colors.strongText),
        ),
        const SizedBox(height: 6),
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: colors.inputBorder),
            borderRadius: BorderRadius.circular(35),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                iconAsset,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  colors.strongText,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  readOnly: readOnly,
                  onTap: onTap,
                  style: AppTextStyles.inputPlaceholder.copyWith(
                    color: colors.strongText,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    hintText: hintText,
                    hintStyle: AppTextStyles.inputPlaceholder.copyWith(
                      color: AppColors.neutralGray,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
