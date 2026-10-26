import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A profile section title ("About Me", "Your Photos") with a small purple
/// edit link on the right (left out when [onAction] is null, e.g. on a
/// friend's profile).
class ProfileSectionHeader extends StatelessWidget {
  const ProfileSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.profileSectionTitle.copyWith(
              color: context.appColors.textPrimary,
            ),
          ),
        ),
        if (onAction != null && actionLabel != null)
          InkWell(
            onTap: onAction,
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(actionLabel!, style: AppTextStyles.profileEditLink),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.edit_outlined,
                    size: 14,
                    color: AppColors.toggleOn,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
