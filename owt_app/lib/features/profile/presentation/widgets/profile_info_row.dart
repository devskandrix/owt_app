import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';
import 'profile_tag_chip.dart';

/// Avatar photo beside the name/verified-badge row, the interest chip, and
/// the tagline.
class ProfileInfoRow extends StatelessWidget {
  const ProfileInfoRow({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = context.appColors.textPrimary;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(child: Assets.images.profileAvatar.image(width: 108, height: 108, fit: BoxFit.cover)),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(AppStrings.profileName, style: AppTextStyles.profileName.copyWith(color: textColor)),
                  const SizedBox(width: 3),
                  SvgPicture.asset(Assets.icons.verifiedBadge, width: 14, height: 14),
                ],
              ),
              const SizedBox(height: 8),
              const ProfileTagChip(),
              const SizedBox(height: 8),
              Text(
                AppStrings.profileTagline,
                style: AppTextStyles.profileTagline.copyWith(color: textColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
