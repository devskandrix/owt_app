import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A single selectable pill chip on the Interests screen. Unselected chips
/// have a plain 1px border; selected chips get the brand gradient border.
class InterestChip extends StatelessWidget {
  const InterestChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(35),
      child: Container(
        height: 35,
        padding: EdgeInsets.all(selected ? 1 : 0),
        decoration: BoxDecoration(
          gradient: selected ? AppGradients.brand : null,
          border: selected ? null : Border.all(color: colors.inputBorder),
          borderRadius: BorderRadius.circular(35),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13),
          alignment: Alignment.center,
          decoration: selected
              ? BoxDecoration(
                  color: colors.background,
                  borderRadius: BorderRadius.circular(34),
                )
              : null,
          child: Text(
            label,
            style: selected
                ? AppTextStyles.chipLabelSelected.copyWith(
                    color: colors.strongText,
                  )
                : AppTextStyles.chipLabel.copyWith(color: colors.textSecondary),
          ),
        ),
      ),
    );
  }
}
