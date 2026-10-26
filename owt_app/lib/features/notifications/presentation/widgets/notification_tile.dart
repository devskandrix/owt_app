import 'package:flutter/material.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/app_notification.dart';

/// A single notification row: title, message and timestamp stacked
/// vertically, with a bottom divider. Unread rows get a purple dot beside
/// the title; read rows are dimmed. Tapping calls [onTap].
class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key, required this.notification, this.onTap});

  final AppNotification notification;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dividerColor = (isDark ? Colors.white : Colors.black).withValues(
      alpha: 0.05,
    );
    final unread = !notification.isRead;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: dividerColor)),
        ),
        child: Opacity(
          opacity: unread ? 1 : 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      titleFor(notification.type),
                      style: AppTextStyles.notificationItemTitle.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                  if (unread)
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(left: 8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.toggleOn,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                notification.message,
                style: AppTextStyles.notificationItemBody.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: double.infinity,
                child: Text(
                  formatTimestamp(notification.createdAt),
                  textAlign: TextAlign.right,
                  style: AppTextStyles.notificationItemDate.copyWith(
                    color: colors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// A readable title for the API's `type`: known types get their own
  /// text, others are prettified ("NEW_MATCH" -> "New match").
  static String titleFor(String type) {
    switch (type) {
      case 'QUEUE_REMOVED_INACTIVITY':
        return AppStrings.notificationQueueRemovedTitle;
    }
    final words = type.toLowerCase().split('_').where((w) => w.isNotEmpty);
    if (words.isEmpty) return AppStrings.notificationDefaultTitle;
    final text = words.join(' ');
    return text[0].toUpperCase() + text.substring(1);
  }

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// "12 Jan 2022 | 12:00 PM", like the Figma.
  static String formatTimestamp(DateTime t) {
    final hour12 = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.hour < 12 ? 'AM' : 'PM';
    return '${t.day} ${_months[t.month - 1]} ${t.year} | '
        '$hour12:$minute $period';
  }
}
