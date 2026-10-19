import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_route.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../gen/assets.gen.dart';

/// "My Profile" title with a settings gear on the trailing edge.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = context.appColors.textPrimary;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Row(
        children: [
          const SizedBox(width: 24),
          Expanded(
            child: Center(
              child: Text(
                AppStrings.profileTitle,
                style: AppTextStyles.sectionTitle.copyWith(color: textColor),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => context.pushNamed(AppRoute.settings.name),
            child: SvgPicture.asset(
              Assets.icons.settingsGear,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
            ),
          ),
        ],
      ),
    );
  }
}
