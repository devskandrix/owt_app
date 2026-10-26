import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/top_notice.dart';
import '../../../settings/presentation/widgets/settings_header.dart';
import '../../../settings/presentation/widgets/settings_row.dart';
import '../widgets/about_feature_card.dart';
import '../widgets/about_gradient_box.dart';
import '../widgets/about_hero.dart';
import '../widgets/about_step_tile.dart';

/// "About App" screen, opened from Settings: what OWT is, how it works,
/// why to use it, safety commitments, a venue-partner call-to-action, and
/// contact details. Theme-aware like the Settings screen it comes from.
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static Future<void> _copyEmail(BuildContext context, String email) async {
    await Clipboard.setData(ClipboardData(text: email));
    if (context.mounted) {
      TopNotice.showSuccess(context, AppStrings.aboutEmailCopied);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SettingsHeader(
              title: AppStrings.aboutTitle,
              showGear: false,
              onBack: () => Navigator.of(context).maybePop(),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  20,
                  16,
                  20,
                  24 + MediaQuery.paddingOf(context).bottom,
                ),
                children: [
                  const AboutHero(),
                  const SizedBox(height: 20),
                  Text(
                    AppStrings.aboutIntro,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.aboutBody.copyWith(
                      color: colors.textMuted,
                    ),
                  ),
                  const _SectionTitle(AppStrings.aboutHowItWorksTitle),
                  const AboutStepTile(
                    number: 1,
                    title: AppStrings.aboutStep1Title,
                    description: AppStrings.aboutStep1Desc,
                  ),
                  const AboutStepTile(
                    number: 2,
                    title: AppStrings.aboutStep2Title,
                    description: AppStrings.aboutStep2Desc,
                  ),
                  const AboutStepTile(
                    number: 3,
                    title: AppStrings.aboutStep3Title,
                    description: AppStrings.aboutStep3Desc,
                  ),
                  const AboutStepTile(
                    number: 4,
                    title: AppStrings.aboutStep4Title,
                    description: AppStrings.aboutStep4Desc,
                    isLast: true,
                  ),
                  const _SectionTitle(AppStrings.aboutWhyTitle),
                  const _CardRow(
                    left: AboutFeatureCard(
                      icon: Icons.nightlife_rounded,
                      title: AppStrings.aboutWhyRealTitle,
                      description: AppStrings.aboutWhyRealDesc,
                    ),
                    right: AboutFeatureCard(
                      icon: Icons.local_fire_department_rounded,
                      title: AppStrings.aboutWhyLiveTitle,
                      description: AppStrings.aboutWhyLiveDesc,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const _CardRow(
                    left: AboutFeatureCard(
                      icon: Icons.verified_rounded,
                      title: AppStrings.aboutWhyVerifiedTitle,
                      description: AppStrings.aboutWhyVerifiedDesc,
                    ),
                    right: AboutFeatureCard(
                      icon: Icons.place_rounded,
                      title: AppStrings.aboutWhyNearbyTitle,
                      description: AppStrings.aboutWhyNearbyDesc,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const _SafetyBox(),
                  const SizedBox(height: 16),
                  AboutGradientBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.aboutPartnerTitle,
                          style: AppTextStyles.aboutItemTitle.copyWith(
                            color: colors.strongText,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          AppStrings.aboutPartnerDesc,
                          style: AppTextStyles.aboutItemDesc.copyWith(
                            color: colors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 14),
                        GradientButton(
                          label: AppStrings.aboutPartnerAction,
                          onPressed: () =>
                              _copyEmail(context, AppStrings.aboutPartnerEmail),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SettingsRow(
                    label: AppStrings.aboutContactUs,
                    showDivider: false,
                    onTap: () =>
                        _copyEmail(context, AppStrings.aboutSupportEmail),
                    trailing: Text(
                      AppStrings.aboutSupportEmail,
                      style: AppTextStyles.aboutItemDesc.copyWith(
                        color: colors.textMuted,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    AppStrings.aboutFooter,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.aboutFooter,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '© ${DateTime.now().year}${AppStrings.aboutCopyrightSuffix}',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.aboutFooter,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 14),
      child: Text(
        text,
        style: AppTextStyles.sectionTitle.copyWith(
          color: context.appColors.textPrimary,
        ),
      ),
    );
  }
}

/// Two feature cards side by side, stretched to the taller one's height.
class _CardRow extends StatelessWidget {
  const _CardRow({required this.left, required this.right});

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: left),
          const SizedBox(width: 12),
          Expanded(child: right),
        ],
      ),
    );
  }
}

class _SafetyBox extends StatelessWidget {
  const _SafetyBox();

  static const _points = [
    AppStrings.aboutSafety1,
    AppStrings.aboutSafety2,
    AppStrings.aboutSafety3,
    AppStrings.aboutSafety4,
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return AboutGradientBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_outlined, color: colors.strongText, size: 22),
              const SizedBox(width: 10),
              Text(
                AppStrings.aboutSafetyTitle,
                style: AppTextStyles.aboutItemTitle.copyWith(
                  color: colors.strongText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final point in _points)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6, right: 10),
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: AppColors.brandPink,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      point,
                      style: AppTextStyles.aboutItemDesc.copyWith(
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
