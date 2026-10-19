import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_gradients.dart';
import '../../../../gen/assets.gen.dart';

/// The floating Cancel (X) and Like (heart) buttons that straddle the
/// photo/tags boundary, mirroring the swipe-left / swipe-right gestures.
class MatchActionButtons extends StatelessWidget {
  const MatchActionButtons({
    super.key,
    required this.onCancel,
    required this.onLike,
  });

  final VoidCallback onCancel;
  final VoidCallback onLike;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onCancel,
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                width: 57,
                height: 57,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.21),
                    width: 1.35,
                  ),
                ),
                child: SvgPicture.asset(
                  Assets.icons.cancelX,
                  width: 57,
                  height: 57,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 74),
        GestureDetector(
          onTap: onLike,
          child: Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppGradients.brand,
            ),
            padding: const EdgeInsets.all(15),
            child: SvgPicture.asset(Assets.icons.likeHeart),
          ),
        ),
      ],
    );
  }
}
