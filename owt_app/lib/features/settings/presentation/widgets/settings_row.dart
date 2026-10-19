import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A single settings list row: a label on the left and arbitrary [trailing]
/// content on the right (a toggle, or nothing for a plain nav row), with a
/// bottom divider — except when [showDivider] is false, used for the last
/// row in a group (Figma's "Log out" row has no trailing divider).
class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.label,
    this.labelStyle,
    this.trailing,
    this.onTap,
    this.showDivider = true,
  });

  final String label;
  final TextStyle? labelStyle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dividerColor = (isDark ? Colors.white : Colors.black).withValues(
      alpha: 0.05,
    );
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          border: showDivider
              ? Border(bottom: BorderSide(color: dividerColor))
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style:
                    labelStyle ??
                    AppTextStyles.settingsRowLabel.copyWith(
                      color: colors.textPrimary,
                    ),
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}
