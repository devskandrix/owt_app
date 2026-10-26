import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/router/app_route.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/top_notice.dart';
import '../../../interests/presentation/widgets/edit_interests_sheet.dart';
import '../../domain/entities/my_profile.dart';
import '../cubit/profile_cubit.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_row.dart';
import '../widgets/profile_photo_grid.dart';
import '../widgets/profile_section_header.dart';
import '../widgets/profile_tag_chip.dart';

/// The signed-in user's own profile screen, reached from the bottom nav's
/// profile avatar. Shows the shared [ProfileCubit] (`GET /users/me`),
/// refreshed each time the tab opens; pull down to refresh too.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileCubit _cubit = sl<ProfileCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.load();
  }

  @override
  Widget build(BuildContext context) {
    // `.value`: the cubit is app-wide, so leaving the tab doesn't close it.
    return BlocProvider.value(value: _cubit, child: const _ProfileView());
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  /// Opens the interests sheet with the current ones selected; reloads
  /// the profile after a save.
  Future<void> _editInterests(BuildContext context, MyProfile profile) async {
    final cubit = context.read<ProfileCubit>();
    final saved = await EditInterestsSheet.show(
      context,
      selectedIds: {for (final interest in profile.interests) ?interest.id},
    );
    if (saved) cubit.load();
  }

  /// Opens the photo editor. Uploads and deletes save as they happen, so
  /// the profile reloads on return however the screen was closed.
  Future<void> _editPhotos(BuildContext context) async {
    final cubit = context.read<ProfileCubit>();
    await context.pushNamed(AppRoute.addPhotos.name, extra: true);
    cubit.load();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.background,
      bottomNavigationBar: const AppBottomNav(active: AppNavTab.profile),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const ProfileHeader(),
            Expanded(
              child: BlocConsumer<ProfileCubit, ProfileState>(
                // A failed refresh keeps the profile and shows a notice.
                listenWhen: (previous, current) =>
                    current.errorMessage != null &&
                    current.errorMessage != previous.errorMessage &&
                    current.profile != null,
                listener: (context, state) =>
                    TopNotice.showError(context, state.errorMessage!),
                builder: (context, state) {
                  final cubit = context.read<ProfileCubit>();
                  final profile = state.profile;
                  if (profile == null &&
                      state.status != ProfileStatus.failure) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (profile == null) {
                    // Scrollable so pulling down retries too.
                    return RefreshIndicator(
                      onRefresh: cubit.load,
                      child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: _LoadFailed(
                              message:
                                  state.errorMessage ??
                                  AppStrings.somethingWentWrong,
                              onRetry: cubit.load,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: cubit.load,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 8),
                          ProfileInfoRow(
                            profile: profile,
                            showInterests: false,
                          ),
                          const SizedBox(height: 20),
                          ProfileSectionHeader(
                            title: AppStrings.interestsLabel,
                            actionLabel: AppStrings.editLabel,
                            onAction: () => _editInterests(context, profile),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final interest in profile.interests)
                                ProfileTagChip(
                                  label: interest.name,
                                  icon: interest.icon,
                                ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ProfileSectionHeader(
                            title: AppStrings.yourPhotosLabel,
                            actionLabel: AppStrings.editPhotosLabel,
                            onAction: () => _editPhotos(context),
                          ),
                          const SizedBox(height: 8),
                          if (profile.photoUrls.isNotEmpty)
                            ProfilePhotoGrid(photoUrls: profile.photoUrls),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
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

class _LoadFailed extends StatelessWidget {
  const _LoadFailed({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.profileBio.copyWith(
                color: context.appColors.textMuted,
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onRetry,
              child: const Text(AppStrings.retryLabel),
            ),
          ],
        ),
      ),
    );
  }
}
