import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/router/app_route.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/top_notice.dart';
import '../../../../gen/assets.gen.dart';
import '../../../chat/presentation/models/chat_args.dart';
import '../../../profile/domain/entities/my_profile.dart';
import '../../../profile/presentation/widgets/profile_info_row.dart';
import '../../../profile/presentation/widgets/profile_photo_grid.dart';
import '../../../profile/presentation/widgets/profile_section_header.dart';
import '../../../profile/presentation/widgets/profile_tag_chip.dart';
import '../cubit/friend_profile_cubit.dart';

/// A friend's (match's) profile, opened from a Friends row. Same layout
/// as the user's own profile (avatar, name, interest, tagline, bio,
/// photos), without the Friends count. Loaded from `GET /matches/:matchId`;
/// pull down to refresh.
class FriendProfilePage extends StatelessWidget {
  const FriendProfilePage({
    super.key,
    required this.matchId,
    this.name,
    this.initial,
  });

  final String matchId;

  /// The Friends list's copy of their profile, shown while it refreshes.
  final MyProfile? initial;

  /// Shown in the header while the profile loads.
  final String? name;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          FriendProfileCubit(matchId, sl(), initial: initial)..load(),
      child: _FriendProfileView(name: name),
    );
  }
}

class _FriendProfileView extends StatelessWidget {
  const _FriendProfileView({this.name});

  final String? name;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: BlocConsumer<FriendProfileCubit, FriendProfileState>(
          // A failed refresh keeps the profile and shows a notice.
          listenWhen: (previous, current) =>
              current.profile != null &&
              current.errorMessage != null &&
              current.errorMessage != previous.errorMessage,
          listener: (context, state) =>
              TopNotice.showError(context, state.errorMessage!),
          builder: (context, state) {
            final cubit = context.read<FriendProfileCubit>();
            final profile = state.profile;
            return Column(
              children: [
                _Header(
                  title: profile?.fullName ?? name ?? AppStrings.friendProfile,
                  onBack: () => Navigator.of(context).maybePop(),
                ),
                Expanded(
                  child: switch (state.status) {
                    FriendProfileStatus.loading when profile == null =>
                      const Center(child: CircularProgressIndicator()),
                    _ => RefreshIndicator(
                      onRefresh: cubit.load,
                      child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          if (profile == null)
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: _LoadFailed(
                                message:
                                    state.errorMessage ??
                                    AppStrings.somethingWentWrong,
                                onRetry: cubit.load,
                              ),
                            )
                          else
                            SliverPadding(
                              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                              sliver: SliverList.list(
                                children: [
                                  ProfileInfoRow(
                                    profile: profile,
                                    showFriends: false,
                                    showInterests: false,
                                  ),
                                  const SizedBox(height: 16),
                                  GradientButton(
                                    label: AppStrings.messageFriend,
                                    onPressed: () => context.pushNamed(
                                      AppRoute.chat.name,
                                      extra: ChatArgs(
                                        userId: profile.id,
                                        name: profile.fullName,
                                        avatarUrl: profile.avatarUrl,
                                      ),
                                    ),
                                  ),
                                  if (profile.interests.isNotEmpty) ...[
                                    const SizedBox(height: 20),
                                    const ProfileSectionHeader(
                                      title: AppStrings.interestsLabel,
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        for (final interest
                                            in profile.interests)
                                          ProfileTagChip(
                                            label: interest.name,
                                            icon: interest.icon,
                                          ),
                                      ],
                                    ),
                                  ],
                                  if (profile.photoUrls.isNotEmpty) ...[
                                    const SizedBox(height: 20),
                                    ProfilePhotoGrid(
                                      photoUrls: profile.photoUrls,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Back chevron + the friend's name, centered.
class _Header extends StatelessWidget {
  const _Header({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final textColor = context.appColors.textPrimary;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            behavior: HitTestBehavior.opaque,
            child: SvgPicture.asset(
              Assets.icons.backChevron,
              width: 9,
              height: 18,
              colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.settingsTitle.copyWith(color: textColor),
            ),
          ),
          // Balances the back chevron so the title stays centered.
          const SizedBox(width: 9),
        ],
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}
