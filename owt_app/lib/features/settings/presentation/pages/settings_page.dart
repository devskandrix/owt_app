import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_switch.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';
import '../widgets/settings_header.dart';
import '../widgets/settings_row.dart';

/// "Setting" screen: notification/dark-mode toggles, a handful of plain nav
/// rows, and a "Log out" action. Page-level chrome (background, text) is
/// theme-aware, matching the rest of the app's non-photo screens — Figma
/// only shows a dark reference, but this isn't a full-bleed photo screen
/// like the Trending carousel or the match card, so it follows the same
/// light/dark rule as Dashboard, Search and Profile.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsHeader(onBack: () => Navigator.of(context).maybePop()),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, state) {
                  final cubit = context.read<SettingsCubit>();
                  return Column(
                    children: [
                      SettingsRow(
                        label: AppStrings.settingsNotification,
                        trailing: AppSwitch(
                          value: state.notificationsEnabled,
                          onChanged: cubit.setNotificationsEnabled,
                        ),
                      ),
                      SettingsRow(
                        label: AppStrings.settingsDarkMode,
                        trailing: AppSwitch(
                          value: state.darkModeEnabled,
                          onChanged: cubit.setDarkMode,
                        ),
                      ),
                      SettingsRow(
                        label: AppStrings.settingsPrivacyPolicy,
                        onTap: () {},
                      ),
                      SettingsRow(
                        label: AppStrings.settingsHelpCenter,
                        onTap: () {},
                      ),
                      SettingsRow(
                        label: AppStrings.settingsAboutApp,
                        onTap: () {},
                      ),
                      SettingsRow(
                        label: AppStrings.settingsDeactivateAccount,
                        onTap: () {},
                      ),
                      SettingsRow(
                        label: AppStrings.settingsLogOut,
                        labelStyle: AppTextStyles.settingsLogOut,
                        showDivider: false,
                        onTap: () {},
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
