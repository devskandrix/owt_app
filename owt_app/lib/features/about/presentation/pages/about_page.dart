import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/top_notice.dart';
import '../../../settings/presentation/widgets/settings_header.dart';
import '../widgets/about_cards.dart';
import '../widgets/about_feature_card.dart';
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
                  const AboutSafetyCard(
                    title: AppStrings.aboutSafetyTitle,
                    points: [
                      AppStrings.aboutSafety1,
                      AppStrings.aboutSafety2,
                      AppStrings.aboutSafety3,
                      AppStrings.aboutSafety4,
                    ],
                  ),
                  const SizedBox(height: 12),
                  AboutPartnerCard(
                    title: AppStrings.aboutPartnerTitle,
                    description: AppStrings.aboutPartnerDesc,
                    actionLabel: AppStrings.aboutPartnerAction,
                    onAction: () =>
                        _copyEmail(context, AppStrings.aboutPartnerEmail),
                  ),
                  const SizedBox(height: 12),
                  AboutContactCard(
                    title: AppStrings.aboutContactUs,
                    email: AppStrings.aboutSupportEmail,
                    onTap: () =>
                        _copyEmail(context, AppStrings.aboutSupportEmail),
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
