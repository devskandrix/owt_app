import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/router/app_route.dart';
import '../../../../core/services/session_service.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_switch.dart';
import '../../../../core/widgets/top_notice.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';
import '../widgets/log_out_dialog.dart';
import '../widgets/settings_header.dart';
import '../widgets/settings_row.dart';
import 'web_page.dart';

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

  Future<void> _confirmLogOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const LogOutDialog(),
    );
    if (confirmed == true) await SessionService.logOut();
  }

  /// Confirms, then deactivates with a blocking spinner. Success signs out
  /// (back to the login screen); failure shows the error and stays here.
  Future<void> _confirmDeactivate(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const LogOutDialog(
        title: AppStrings.deactivateConfirmTitle,
        message: AppStrings.deactivateConfirmMessage,
        confirmLabel: AppStrings.deactivateConfirmLabel,
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final navigator = Navigator.of(context, rootNavigator: true);
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
    try {
      await SessionService.deactivateAccount();
    } on Failure catch (f) {
      navigator.pop();
      if (context.mounted) TopNotice.showError(context, f.message);
      return;
    } catch (_) {
      navigator.pop();
      if (context.mounted) {
        TopNotice.showError(context, AppStrings.somethingWentWrong);
      }
      return;
    }
    // Close the spinner before signing out navigates to the login screen.
    navigator.pop();
    await SessionService.signOut();
  }

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
                        onTap: () => context.pushNamed(
                          AppRoute.webPage.name,
                          extra: WebPageArgs.privacyPolicy,
                        ),
                      ),
                      SettingsRow(
                        label: AppStrings.settingsHelpCenter,
                        onTap: () => context.pushNamed(
                          AppRoute.webPage.name,
                          extra: WebPageArgs.helpCenter,
                        ),
                      ),
                      SettingsRow(
                        label: AppStrings.settingsAboutApp,
                        onTap: () => context.pushNamed(AppRoute.about.name),
                      ),
                      SettingsRow(
                        label: AppStrings.settingsDeactivateAccount,
                        onTap: () => _confirmDeactivate(context),
                      ),
                      SettingsRow(
                        label: AppStrings.settingsLogOut,
                        labelStyle: AppTextStyles.settingsLogOut,
                        showDivider: false,
                        onTap: () => _confirmLogOut(context),
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
