import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../gen/assets.gen.dart';

/// Orange -> pink circle with the white flame — the Going Tonight mark at
/// the top of each sheet/dialog (74px) and on each benefit row (46px).
class GoingTonightIcon extends StatelessWidget {
  const GoingTonightIcon({super.key, this.size = 74});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFFFC6909), Color(0xFFD81372)],
        ),
      ),
      // Flame height relative to the circle, per Figma (38 of 74).
      child: SvgPicture.asset(
        Assets.icons.goingTonightFire,
        height: size * 0.514,
      ),
    );
  }
}
