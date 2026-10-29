import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';

/// A rounded square with the button gradient and a white icon, used as the
/// leading badge on the About page's cards.
class AboutIconBadge extends StatelessWidget {
  const AboutIconBadge({super.key, required this.icon, this.size = 40});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppGradients.button,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Icon(icon, color: Colors.white, size: size * 0.5),
    );
  }
}

/// "Your safety comes first": a softly brand-tinted card with a check
/// for each point.
class AboutSafetyCard extends StatelessWidget {
  const AboutSafetyCard({
    super.key,
    required this.title,
    required this.points,
  });

  final String title;
  final List<String> points;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.brandPink.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.brandPink.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AboutIconBadge(icon: Icons.shield_rounded),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.aboutItemTitle.copyWith(
                    fontSize: 15,
                    color: colors.strongText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          for (final (i, point) in points.indexed)
            Padding(
              padding: EdgeInsets.only(bottom: i == points.length - 1 ? 0 : 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 1, right: 10),
                    child: ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: AppGradients.button.createShader,
                      child: const Icon(
                        Icons.check_circle_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      point,
                      style: AppTextStyles.aboutItemDesc.copyWith(
                        fontSize: 13,
                        color: colors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// "Own a club or venue?": a gradient-washed card with a store badge and
/// a compact "Connect" pill.
class AboutPartnerCard extends StatelessWidget {
  const AboutPartnerCard({
    super.key,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String description;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.brandPurple.withValues(alpha: 0.4)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.brandPink.withValues(alpha: 0.14),
            AppColors.brandPurple.withValues(alpha: 0.06),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AboutIconBadge(icon: Icons.storefront_rounded),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.aboutItemTitle.copyWith(
                    fontSize: 15,
                    color: colors.strongText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: AppTextStyles.aboutItemDesc.copyWith(
              fontSize: 13,
              color: colors.textMuted,
            ),
          ),
          const SizedBox(height: 14),
          _PillButton(label: actionLabel, onTap: onAction),
        ],
      ),
    );
  }
}

/// Small gradient pill with a trailing arrow.
class _PillButton extends StatelessWidget {
  const _PillButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: AppGradients.button,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 9, 14, 9),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: AppTextStyles.primaryButton.copyWith(fontSize: 14),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// "Contact Us": a tappable card with a mail badge, the address and a copy
/// icon.
class AboutContactCard extends StatelessWidget {
  const AboutContactCard({
    super.key,
    required this.title,
    required this.email,
    required this.onTap,
  });

  final String title;
  final String email;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.inputBorder),
          ),
          child: Row(
            children: [
              const AboutIconBadge(icon: Icons.mail_rounded),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.aboutItemTitle.copyWith(
                        fontSize: 15,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      email,
                      style: AppTextStyles.aboutItemDesc.copyWith(
                        fontSize: 13,
                        color: colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.copy_rounded, size: 18, color: colors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
