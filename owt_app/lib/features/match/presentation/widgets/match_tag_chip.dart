import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_text_styles.dart';

/// An "Interested In" pill: a small icon plus a label inside a
/// faint-bordered pill. [icon] is pre-built so callers can pass either a
/// tinted [SvgPicture] or one with its own baked-in colors.
class MatchTagChip extends StatelessWidget {
  const MatchTagChip({super.key, required this.icon, required this.label});

  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 14, height: 14, child: icon),
          const SizedBox(width: 6),
          Text(label, style: AppTextStyles.matchTagLabel),
        ],
      ),
    );
  }
}
