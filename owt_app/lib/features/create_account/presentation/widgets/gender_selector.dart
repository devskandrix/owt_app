import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';
import '../../../auth/domain/entities/gender.dart';

/// "Male / Female / Other" radio row on the Create Account screen.
class GenderSelector extends StatelessWidget {
  const GenderSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final Gender? selected;
  final ValueChanged<Gender> onChanged;

  static const _options = [
    (value: Gender.male, label: AppStrings.genderMale),
    (value: Gender.female, label: AppStrings.genderFemale),
    (value: Gender.other, label: AppStrings.genderOther),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final option in _options) ...[
          if (option != _options.first) const SizedBox(width: 6),
          Expanded(
            // Plain tap target (no Material ripple): the filled dot is the
            // selection feedback, and an InkWell's splash spilled over the
            // surrounding title and fields.
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(option.value),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _RadioDot(selected: selected == option.value),
                  const SizedBox(width: 8),
                  Text(
                    option.label,
                    style: AppTextStyles.inputPlaceholder.copyWith(
                      color: AppColors.neutralGray,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    if (!selected) {
      return SvgPicture.asset(Assets.icons.radioOutline, width: 24, height: 24);
    }
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.brandPink, width: 1.5),
      ),
      child: Center(
        child: Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.brandPink,
          ),
        ),
      ),
    );
  }
}
