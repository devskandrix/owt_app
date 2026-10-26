import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_text.dart';
import '../../../../gen/assets.gen.dart';

/// OWT logo, the brand-gradient tagline, and the installed app version.
class AboutHero extends StatefulWidget {
  const AboutHero({super.key});

  @override
  State<AboutHero> createState() => _AboutHeroState();
}

class _AboutHeroState extends State<AboutHero> {
  final Future<PackageInfo> _packageInfo = PackageInfo.fromPlatform();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      children: [
        Assets.images.owtLogoPng.image(height: 56, fit: BoxFit.contain),
        const SizedBox(height: 12),
        GradientText(
          AppStrings.tagline,
          gradient: AppGradients.brand,
          // The splash tagline's dark glow reads as a box on this page.
          style: AppTextStyles.tagline.copyWith(shadows: const []),
        ),
        const SizedBox(height: 8),
        FutureBuilder<PackageInfo>(
          future: _packageInfo,
          builder: (context, snapshot) {
            final info = snapshot.data;
            // A blank line until it loads (or if it fails) keeps the
            // layout from jumping.
            return Text(
              info == null
                  ? ' '
                  : '${AppStrings.aboutVersionPrefix}'
                        '${info.version} (${info.buildNumber})',
              style: AppTextStyles.aboutVersion.copyWith(
                color: colors.textMuted,
              ),
            );
          },
        ),
      ],
    );
  }
}
