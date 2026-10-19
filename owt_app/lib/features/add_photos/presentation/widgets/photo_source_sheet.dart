import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Modal bottom sheet offering "Take Photo" / "Choose from Gallery", used
/// when the user taps an empty photo slot on the Add Photos screen. Returns
/// the chosen [ImageSource], or null if dismissed without a choice.
class PhotoSourceSheet extends StatelessWidget {
  const PhotoSourceSheet({super.key});

  static Future<ImageSource?> show(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const PhotoSourceSheet(),
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
              AppStrings.choosePhotoSourceTitle,
              style: AppTextStyles.fieldLabel.copyWith(
                color: colors.strongText,
              ),
            ),
            const SizedBox(height: 8),
            _SourceTile(
              icon: Icons.photo_camera_outlined,
              label: AppStrings.takePhoto,
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            _SourceTile(
              icon: Icons.photo_library_outlined,
              label: AppStrings.chooseFromGallery,
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _SourceTile extends StatelessWidget {
  const _SourceTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: colors.strongText),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTextStyles.inputPlaceholder.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
