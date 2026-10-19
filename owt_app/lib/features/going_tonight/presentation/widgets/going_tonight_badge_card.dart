import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/gradient_text.dart';
import '../../../../gen/assets.gen.dart';
import 'going_tonight_icon.dart';

/// Full-card "Going Tonight" promo dropped into the match deck for users
/// without the badge: a dimmed crowd photo with the badge pitch centered on
/// top, and a close (X) to dismiss it.
class GoingTonightBadgeCard extends StatefulWidget {
  const GoingTonightBadgeCard({
    super.key,
    required this.onVerify,
    required this.onClose,
  });

  final VoidCallback onVerify;
  final VoidCallback onClose;

  @override
  State<GoingTonightBadgeCard> createState() => _GoingTonightBadgeCardState();
}

class _GoingTonightBadgeCardState extends State<GoingTonightBadgeCard> {
  bool _showHowTo = false;

  static const Color _background = Color(0xFF0A0B0D);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Photo is exported at 40% opacity; Figma layers a flat 20% black
        // and a fade to the page background over it.
        Positioned(
          top: 12,
          left: 0,
          right: 0,
          height: 680,
          child: DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.345, 0.967],
                colors: [Color(0x33000000), _background],
              ),
            ),
            child: Assets.images.goingTonightPromoBg.image(fit: BoxFit.cover),
          ),
        ),
        Positioned.fill(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(45, 68, 45, 24),
            child: Column(
              children: [
                const GoingTonightIcon(),
                const SizedBox(height: 20),
                const Text(
                  AppStrings.goingTonightHeadline,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.goingTonightHeadline,
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    AppStrings.goingTonightSubtitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.goingTonightSubtitle,
                  ),
                ),
                const SizedBox(height: 20),
                const _BenefitRow(
                  title: AppStrings.goingTonightBenefitConversationsTitle,
                ),
                const SizedBox(height: 20),
                const _BenefitRow(
                  title: AppStrings.goingTonightBenefitLocationTitle,
                ),
                const SizedBox(height: 20),
                const _BenefitRow(
                  title: AppStrings.goingTonightBenefitPrivacyTitle,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: SizedBox(
                    width: double.infinity,
                    child: GradientButton(
                      label: AppStrings.goingTonightVerifyMine,
                      onPressed: widget.onVerify,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => setState(() => _showHowTo = !_showHowTo),
                  child: const GradientText(
                    AppStrings.goingTonightHowToGetBadge,
                    gradient: AppGradients.brand,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.goingTonightLink,
                  ),
                ),
                if (_showHowTo) ...[
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      AppStrings.goingTonightHowToGetBadgeAnswer,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.goingTonightBody,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        // 18px X 22px into the photo and 25px from the right, padded for a
        // usable tap target.
        Positioned(
          top: 24,
          right: 15,
          child: GestureDetector(
            onTap: widget.onClose,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(
                Assets.icons.closeWhite,
                width: 18,
                height: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const GoingTonightIcon(size: 46),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.goingTonightBenefitTitle),
                const SizedBox(height: 4),
                const Text(
                  AppStrings.goingTonightBenefitBody,
                  style: AppTextStyles.goingTonightBenefitBody,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
