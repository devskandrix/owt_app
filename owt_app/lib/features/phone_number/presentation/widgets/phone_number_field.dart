import 'package:flutter/material.dart';

import '../../../../core/data/country.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/country_flag_badge.dart';

/// Rounded phone-number input with a circular country flag and dropdown
/// chevron, matching the "Numbet" frame in Figma exactly (no dial-code
/// text or divider is shown in the field itself).
class PhoneNumberField extends StatelessWidget {
  const PhoneNumberField({
    super.key,
    required this.controller,
    required this.country,
    required this.onCountryTap,
  });

  final TextEditingController controller;
  final Country country;
  final VoidCallback onCountryTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: colors.inputBorder),
        borderRadius: BorderRadius.circular(35),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onCountryTap,
            borderRadius: BorderRadius.circular(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CountryFlagBadge(country: country, size: 28),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: colors.textMuted,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              style: AppTextStyles.inputPlaceholder.copyWith(
                color: colors.textSecondary,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: AppStrings.enterPhoneNumberHint,
                hintStyle: AppTextStyles.inputPlaceholder.copyWith(
                  color: colors.textMuted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
