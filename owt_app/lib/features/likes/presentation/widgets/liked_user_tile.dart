import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';
import '../../../matchmaking/domain/entities/received_like.dart';
import 'likes_avatars.dart';
import 'person_row.dart';

/// One like: avatar, name, location, club, and Confirm / dismiss (X).
class LikedUserTile extends StatelessWidget {
  const LikedUserTile({
    super.key,
    required this.like,
    required this.onConfirm,
    required this.onDismiss,
    this.busy = false,
  });

  final ReceivedLike like;
  final VoidCallback onConfirm;
  final VoidCallback onDismiss;

  /// Accept in flight: Confirm shows a spinner and both actions are off.
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return PersonRow(
      avatar: likeAvatar(like),
      name: like.name,
      location: like.location,
      clubName: like.clubName,
      clubImageUrl: like.clubImageUrl,
      trailing: [
        _ConfirmButton(onPressed: busy ? null : onConfirm, busy: busy),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: busy ? null : onDismiss,
          behavior: HitTestBehavior.opaque,
          child: SvgPicture.asset(
            Assets.icons.closeSmall,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(colors.textPrimary, BlendMode.srcIn),
          ),
        ),
      ],
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({required this.onPressed, this.busy = false});

  final VoidCallback? onPressed;
  final bool busy;

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
          child: SizedBox(
            height: 36,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: Center(
                // Keeps the button's width while the spinner shows.
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: busy ? 0 : 1,
                      child: const Text(
                        AppStrings.likesConfirm,
                        style: AppTextStyles.likesConfirm,
                      ),
                    ),
                    if (busy)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
