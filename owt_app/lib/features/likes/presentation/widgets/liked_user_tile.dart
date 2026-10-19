import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';
import '../../domain/entities/liked_user.dart';

/// One like: avatar, name, location, club, and Confirm / dismiss (X).
class LikedUserTile extends StatelessWidget {
  const LikedUserTile({
    super.key,
    required this.user,
    required this.avatar,
    required this.onConfirm,
    required this.onDismiss,
  });

  final LikedUser user;
  final AssetGenImage avatar;
  final VoidCallback onConfirm;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return SizedBox(
      height: 58,
      child: Row(
        children: [
          ClipOval(
            child: avatar.image(width: 58, height: 58, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.likesName.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(user.location, style: AppTextStyles.likesCaption),
                const SizedBox(height: 4),
                Row(
                  children: [
                    ClipOval(
                      child: Assets.images.likesClubIcon.image(
                        width: 18,
                        height: 18,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        user.clubName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.likesClub.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _ConfirmButton(onPressed: onConfirm),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onDismiss,
            behavior: HitTestBehavior.opaque,
            child: SvgPicture.asset(
              Assets.icons.closeSmall,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                colors.textPrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({required this.onPressed});

  final VoidCallback onPressed;

  static const BorderRadius _radius = BorderRadius.all(Radius.circular(38));

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: AppGradients.button,
        borderRadius: _radius,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: _radius,
          onTap: onPressed,
          child: const SizedBox(
            height: 36,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 17),
              child: Center(
                child: Text(
                  AppStrings.likesConfirm,
                  style: AppTextStyles.likesConfirm,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
