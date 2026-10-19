import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// One slot in the 3x2 photo grid on the "Add your photos" screen: an
/// empty slot with a "+" affordance, an uploading placeholder, or a filled
/// slot (with a remove "x", dimmed with a spinner while it's being deleted).
class PhotoSlot extends StatelessWidget {
  const PhotoSlot({
    super.key,
    this.imageUrl,
    this.isUploading = false,
    this.isDeleting = false,
    this.onTap,
    this.onRemove,
  });

  final String? imageUrl;
  final bool isUploading;
  final bool isDeleting;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final emptyBorderColor = isDark
        ? const Color(0xFFF2F4F7)
        : colors.textPrimary;
    final addIconBgColor = isDark
        ? const Color(0x0AFFFFFF)
        : colors.inputBorder;
    final filled = imageUrl != null;

    return AspectRatio(
      aspectRatio: 105 / 128,
      child: GestureDetector(
        onTap: filled || isUploading ? null : onTap,
        child: Container(
          decoration: BoxDecoration(
            color: colors.background,
            border: filled || isUploading
                ? null
                : Border.all(color: emptyBorderColor),
          ),
          child: filled
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) => ColoredBox(
                          color: colors.inputBorder,
                          child: Icon(
                            Icons.error_outline,
                            color: colors.textMuted,
                          ),
                        ),
                      ),
                    ),
                    if (isDeleting)
                      const Positioned.fill(
                        child: ColoredBox(
                          color: Color(0x66000000),
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: onRemove,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0x66000000),
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                )
              : isUploading
              ? const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : Center(
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: addIconBgColor,
                    ),
                    child: Icon(Icons.add, size: 16, color: colors.strongText),
                  ),
                ),
        ),
      ),
    );
  }
}
