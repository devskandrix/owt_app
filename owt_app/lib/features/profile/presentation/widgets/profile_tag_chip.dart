import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';

/// An interest pill (e.g. "🎤 Hip Hop"): the interest's emoji (or the
/// palm tree from Figma when it has none) plus a themed label inside a
/// bordered pill. Border flips to a dark base color in light
/// theme so it stays visible against the light scaffold background.
class ProfileTagChip extends StatelessWidget {
  const ProfileTagChip({super.key, required this.label, this.icon});

  final String label;

  /// Emoji shown before the label; null shows the palm tree.
  final String? icon;

  @override
  Widget build(BuildContext context) {
    final textColor = context.appColors.textPrimary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? Colors.white : Colors.black;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor.withValues(alpha: 0.1)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon case final emoji?)
            SizedBox(
              width: 16,
              height: 16,
              child: Center(
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 12, height: 1),
                ),
              ),
            )
          else
            SvgPicture.asset(Assets.icons.palmTree, width: 16, height: 16),
          const SizedBox(width: 2),
          Text(
            label,
            style: AppTextStyles.profileTagLabel.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}
