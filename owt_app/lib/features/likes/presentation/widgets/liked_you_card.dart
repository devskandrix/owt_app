import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';

/// "Liked You" summary at the top of the Likes screen: gradient heart,
/// title + description, and a stack of avatars with a "+N" count.
class LikedYouCard extends StatelessWidget {
  const LikedYouCard({super.key, required this.previews, required this.extra});

  /// Up to three avatars shown overlapping.
  final List<AssetGenImage> previews;

  /// Count in the trailing "+N" pill; hidden when zero.
  final int extra;

  static const double _avatarSize = 36;

  /// Avatars overlap by this much, per Figma.
  static const double _overlap = 9.5;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: colors.textPrimary.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          SvgPicture.asset(Assets.icons.likedYouHeart, width: 40, height: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.likedYouTitle,
                  style: AppTextStyles.likesName.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  AppStrings.likedYouSubtitle,
                  style: AppTextStyles.likesCaption,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Each avatar (and the last one, when the pill follows) only
          // takes up its width minus the overlap, so the next one sits on
          // top of it.
          for (final (i, avatar) in previews.indexed)
            Align(
              alignment: Alignment.centerLeft,
              widthFactor: i < previews.length - 1 || extra > 0
                  ? (_avatarSize - _overlap) / _avatarSize
                  : 1,
              child: ClipOval(
                child: avatar.image(
                  width: _avatarSize,
                  height: _avatarSize,
                  fit: BoxFit.cover,
                ),
              ),
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
