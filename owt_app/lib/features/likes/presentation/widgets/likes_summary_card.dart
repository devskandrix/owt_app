import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';
import 'likes_avatars.dart';

/// Gradient heart, title + gray description, and a stack of overlapping
/// avatars with a "+N" pill. Used as "Liked You" on the Likes screen
/// (bordered) and "Pending Request" on User Detail (borderless).
class LikesSummaryCard extends StatelessWidget {
  const LikesSummaryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.previews,
    required this.extra,
    this.bordered = true,
    this.firstAvatarSize = _avatarSize,
    this.textColor,
  });

  final String title;
  final String subtitle;

  /// Avatars shown overlapping, left to right.
  final List<ImageProvider> previews;

  /// Count in the trailing "+N" pill; hidden when zero.
  final int extra;

  final bool bordered;

  /// Figma draws the first avatar larger on User Detail (44 vs 36).
  final double firstAvatarSize;

  /// Title color; defaults to the theme's primary text color.
  final Color? textColor;

  static const double _avatarSize = 36;

  /// Avatars overlap by this much, per Figma.
  static const double _overlap = 9.5;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final titleColor = textColor ?? colors.textPrimary;
    return Container(
      padding: bordered
          ? const EdgeInsets.all(10)
          : const EdgeInsets.symmetric(vertical: 10),
      decoration: bordered
          ? BoxDecoration(
              border: Border.all(color: titleColor.withValues(alpha: 0.05)),
            )
          : null,
      child: Row(
        children: [
          SvgPicture.asset(Assets.icons.likedYouHeart, width: 40, height: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.likesName.copyWith(color: titleColor),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTextStyles.likesCaption),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Each avatar (and the last one, when the pill follows) only
          // takes up its width minus the overlap, so the next one sits on
          // top of it.
          for (final (i, avatar) in previews.indexed)
            Builder(
              builder: (context) {
                final size = i == 0 ? firstAvatarSize : _avatarSize;
                return Align(
                  alignment: Alignment.centerLeft,
                  widthFactor: i < previews.length - 1 || extra > 0
                      ? (size - _overlap) / size
                      : 1,
                  child: LikeCircleImage(image: avatar, size: size),
                );
              },
            ),
          if (extra > 0)
            Container(
              height: 31,
              padding: const EdgeInsets.symmetric(horizontal: 7.5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: AppGradients.button,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                '+$extra',
                style: AppTextStyles.likesName.copyWith(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
