import 'package:flutter/material.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// "Log out?" confirmation. Pops `true` when the user confirms. Themed like
/// the Settings screen, with the confirm action in the same danger red as
/// the "Log out" row. The texts can be swapped for other destructive
/// confirmations (e.g. Deactivate Account).
class LogOutDialog extends StatelessWidget {
  const LogOutDialog({
    super.key,
    this.title = AppStrings.logOutConfirmTitle,
    this.message = AppStrings.logOutConfirmMessage,
    this.confirmLabel = AppStrings.settingsLogOut,
  });

  final String title;
  final String message;
  final String confirmLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Dialog(
      backgroundColor: colors.background,
      insetPadding: const EdgeInsets.symmetric(horizontal: 45),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.textPrimary.withValues(alpha: 0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.sectionTitle.copyWith(
                fontSize: 18,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.authSubtitle.copyWith(
                fontSize: 14,
                color: colors.textMuted,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      AppStrings.cancelLabel,
                      style: AppTextStyles.settingsLogOut.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(
                      confirmLabel,
                      style: AppTextStyles.settingsLogOut.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
