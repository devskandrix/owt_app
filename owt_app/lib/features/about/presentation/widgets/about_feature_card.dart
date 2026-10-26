import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A "Why OWT" card: brand-gradient icon, title and short description on a
/// subtly bordered tile.
class AboutFeatureCard extends StatelessWidget {
  const AboutFeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: AppGradients.brand.createShader,
            child: Icon(icon, size: 26, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: AppTextStyles.aboutItemTitle.copyWith(
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: AppTextStyles.aboutItemDesc.copyWith(
              color: colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
