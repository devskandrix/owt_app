import 'package:flutter/material.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A single notification row: bold title, description and timestamp
/// stacked vertically, with a bottom divider. Figma defines a leading
/// avatar/bell icon for this row, but it's marked hidden in the source
/// file, so every row here is plain text only.
class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dividerColor = (isDark ? Colors.white : Colors.black).withValues(
      alpha: 0.05,
    );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: dividerColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.notificationUnreadViewTitle,
            style: AppTextStyles.notificationItemTitle.copyWith(
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            AppStrings.notificationUnreadViewBody,
            style: AppTextStyles.notificationItemBody.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: Text(
              AppStrings.notificationTimestamp,
              textAlign: TextAlign.right,
              style: AppTextStyles.notificationItemDate.copyWith(color: colors.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}
