import 'package:flutter/material.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

enum PhotoAction { replace, delete }

/// Modal bottom sheet shown when the user taps one of their photos while
/// editing from Profile: "Replace Photo" / "Delete Photo". Returns the
/// chosen [PhotoAction], or null if dismissed.
class PhotoActionSheet extends StatelessWidget {
  const PhotoActionSheet({super.key});

  static Future<PhotoAction?> show(BuildContext context) {
    return showModalBottomSheet<PhotoAction>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const PhotoActionSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.inputBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.photoOptionsTitle,
              style: AppTextStyles.fieldLabel.copyWith(
                color: colors.strongText,
              ),
            ),
            const SizedBox(height: 8),
            _ActionTile(
              icon: Icons.swap_horiz,
              label: AppStrings.replacePhoto,
              color: colors.textSecondary,
              onTap: () => Navigator.of(context).pop(PhotoAction.replace),
            ),
            _ActionTile(
              icon: Icons.delete_outline,
              label: AppStrings.deletePhoto,
              color: AppColors.dangerRed,
              onTap: () => Navigator.of(context).pop(PhotoAction.delete),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTextStyles.inputPlaceholder.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
