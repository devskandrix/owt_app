import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/router/app_route.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/top_notice.dart';
import '../../../../gen/assets.gen.dart';
import '../../../chat/presentation/models/chat_args.dart';
import '../../../likes/presentation/widgets/person_row.dart';
import '../cubit/friends_cubit.dart';

/// "Friends": everyone the user has matched with (`GET /matches`), opened
/// from the Friends count on Profile. Rows look like the Likes list, with
/// a message button in place of Confirm / X; tap a row to open their
/// profile. Pull down to refresh.
class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FriendsCubit>()..load(),
      child: const _FriendsView(),
    );
  }
}

class _FriendsView extends StatelessWidget {
  const _FriendsView();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            _Header(onBack: () => Navigator.of(context).maybePop()),
            Expanded(
              child: BlocConsumer<FriendsCubit, FriendsState>(
                // A failed refresh keeps the list and shows a notice.
                listenWhen: (previous, current) =>
                    current.status == FriendsStatus.ready &&
                    current.errorMessage != null &&
                    current.errorMessage != previous.errorMessage,
                listener: (context, state) =>
                    TopNotice.showError(context, state.errorMessage!),
                builder: (context, state) {
                  final cubit = context.read<FriendsCubit>();
                  if (state.status == FriendsStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return RefreshIndicator(
                    onRefresh: cubit.load,
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        if (state.status == FriendsStatus.failure)
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: _Message(
                              text:
                                  state.errorMessage ??
                                  AppStrings.somethingWentWrong,
                              onRetry: cubit.load,
                            ),
                          )
                        else if (state.friends.isEmpty)
                          const SliverFillRemaining(
                            hasScrollBody: false,
                            child: _Message(text: AppStrings.friendsEmpty),
                          )
                        else
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                            sliver: SliverList.separated(
                              itemCount: state.friends.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 22),
                              itemBuilder: (context, index) {
                                final friend = state.friends[index];
                                final url = friend.avatarUrl;
                                return GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => context.pushNamed(
                                    AppRoute.friendProfile.name,
                                    extra: friend,
                                  ),
                                  child: PersonRow(
                                    avatar: url != null
                                        ? NetworkImage(url)
                                        : Assets.images.profileAvatar
                                              .provider(),
                                    name: friend.name,
                                    location: friend.location,
                                    clubName: friend.clubName,
                                    clubImageUrl: friend.clubImageUrl,
                                    trailing: [
                                      _MessageButton(
                                        onTap: () => context.pushNamed(
                                          AppRoute.chat.name,
                                          extra: ChatArgs(
                                            matchId: friend.matchId,
                                            userId: friend.userId,
                                            name: friend.name,
                                            avatarUrl: friend.avatarUrl,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
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

/// Back chevron + centered "Friends" title.
class _Header extends StatelessWidget {
  const _Header({required this.onBack});

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
            child: Center(
              child: Text(
                AppStrings.profileFriends,
                style: AppTextStyles.settingsTitle.copyWith(color: textColor),
              ),
            ),
          ),
          // Balances the back chevron so the title stays centered.
          const SizedBox(width: 9),
        ],
      ),
    );
  }
}

/// Centered empty / error text, with a retry button for errors.
class _Message extends StatelessWidget {
  const _Message({required this.text, this.onRetry});

  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: AppTextStyles.likesName.copyWith(
              color: context.appColors.textMuted,
            ),
          ),
          if (onRetry case final retry?) ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: retry,
              child: const Text(AppStrings.retryLabel),
            ),
          ],
        ],
      ),
    );
  }
}

/// Round button on a friend's row that opens the chat with them.
class _MessageButton extends StatelessWidget {
  const _MessageButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: AppStrings.messageFriend,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.toggleOn.withValues(alpha: 0.15),
          ),
          child: const Icon(
            Icons.chat_bubble_outline,
            size: 20,
            color: AppColors.toggleOn,
          ),
        ),
      ),
    );
  }
}
