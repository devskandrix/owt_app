import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../gen/assets.gen.dart';

/// Back chevron + centered wordmark + filter/bell icons on the match
/// screen. Fixed white/dark, matching the rest of this full-bleed photo
/// screen (no light Figma frame exists for it).
class MatchHeader extends StatelessWidget {
  const MatchHeader({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: SvgPicture.asset(
              Assets.icons.backChevron,
              width: 9,
              height: 18,
            ),
          ),
          Expanded(
            child: Center(
              child: Assets.images.owtLogoPng.image(
                height: 28,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SvgPicture.asset(
            Assets.icons.filter,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          const SizedBox(width: 14),
          SvgPicture.asset(
            Assets.icons.bell,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ],
      ),
    );
  }
}
