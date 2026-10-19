import 'package:flutter/material.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_row.dart';
import '../widgets/profile_photo_grid.dart';

/// The signed-in user's own profile screen, reached from the bottom nav's
/// profile avatar.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = context.appColors.textPrimary;
    return Scaffold(
      backgroundColor: context.appColors.background,
      bottomNavigationBar: const AppBottomNav(active: AppNavTab.profile),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const ProfileHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    const ProfileInfoRow(),
                    const SizedBox(height: 20),
                    Text(
                      AppStrings.profileBio,
                      style: AppTextStyles.profileBio.copyWith(color: textColor),
                    ),
                    const SizedBox(height: 20),
                    const ProfilePhotoGrid(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
