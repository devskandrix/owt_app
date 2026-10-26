import 'dart:async';

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
import '../../../matchmaking/domain/entities/received_like.dart';
import '../cubit/likes_cubit.dart';
import '../cubit/likes_state.dart';
import '../../../notifications/presentation/widgets/notification_bell.dart';
import '../widgets/liked_user_tile.dart';
import '../widgets/likes_avatars.dart';
import '../widgets/likes_summary_card.dart';
import '../widgets/match_banner.dart';
import 'user_detail_page.dart';

/// "Likes" tab: a "Liked You" summary, then everyone who liked the user
/// (from `GET /matchmaking/likes/received`, loaded a page at a time as the
/// list scrolls), each with Confirm (accepts; the row turns into an
/// "It’s Match" banner) and X (declines). Pull down to refresh.
/// Theme-aware like the app's other non-photo screens; Figma only shows
/// the dark version.
class LikesPage extends StatelessWidget {
  const LikesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LikesCubit>()..load(),
      child: const _LikesView(),
    );
  }
}

class _LikesView extends StatefulWidget {
  const _LikesView();

  @override
  State<_LikesView> createState() => _LikesViewState();
}

class _LikesViewState extends State<_LikesView> {
  StreamSubscription<LikesNotice>? _notices;

  /// Starts loading the next page this far from the end of the list.
  static const double _loadMoreExtent = 300;

  @override
  void initState() {
    super.initState();
    _notices = context.read<LikesCubit>().notices.listen((notice) {
      if (!mounted) return;
      switch (notice) {
        case LikesErrorNotice(:final message):
          TopNotice.showError(context, message);
      }
    });
  }

  @override
  void dispose() {
    _notices?.cancel();
    super.dispose();
  }

  /// Opens the pending-request deck at [like]. Decisions made there go
  /// straight into this screen's [LikesCubit], so the list is up to date
  /// on return.
  void _openDetail(ReceivedLike like) {
    context.pushNamed(
      AppRoute.userDetail.name,
      extra: UserDetailArgs(
        cubit: context.read<LikesCubit>(),
        startLikeId: like.likeId,
      ),
    );
  }

  bool _onScroll(ScrollNotification notification) {
    final metrics = notification.metrics;
    if (metrics.axis == Axis.vertical &&
        metrics.extentAfter < _loadMoreExtent) {
      context.read<LikesCubit>().loadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.background,
      bottomNavigationBar: const AppBottomNav(active: AppNavTab.likes),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<LikesCubit, LikesState>(
          builder: (context, state) {
            final cubit = context.read<LikesCubit>();
            final previews = likePreviews(state.pending);
            final hidden = state.totalLikes - previews.length;
            return NotificationListener<ScrollNotification>(
              onNotification: _onScroll,
              child: RefreshIndicator(
                onRefresh: cubit.load,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(child: _Header(colors: colors)),
                    if (state.status == LikesStatus.ready)
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 35),
                        sliver: SliverToBoxAdapter(
                          child: LikesSummaryCard(
                            title: AppStrings.likedYouTitle,
                            subtitle: AppStrings.likedYouSubtitle,
                            previews: previews,
                            extra: hidden > 0 ? hidden : 0,
                          ),
                        ),
                      ),
                    ...switch (state.status) {
                      LikesStatus.loading => [
                        const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      ],
                      LikesStatus.failure => [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: _Message(
                            text:
                                state.errorMessage ??
                                AppStrings.somethingWentWrong,
                            onRetry: cubit.load,
                          ),
                        ),
                      ],
                      LikesStatus.ready when state.likes.isEmpty => [
                        const SliverFillRemaining(
                          hasScrollBody: false,
                          child: _Message(text: AppStrings.likesEmpty),
                        ),
                      ],
                      LikesStatus.ready => [
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                          sliver: SliverList.separated(
                            itemCount: state.likes.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 22),
                            itemBuilder: (context, index) {
                              final like = state.likes[index];
                              if (state.matchedIds.contains(like.likeId)) {
                                return MatchBanner(
                                  onDismiss: () =>
                                      cubit.dismissMatch(like.likeId),
                                );
                              }
                              final busy = state.busyIds.contains(like.likeId);
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: busy ? null : () => _openDetail(like),
                                child: LikedUserTile(
                                  like: like,
                                  busy: busy,
                                  onConfirm: () => cubit.accept(like.likeId),
                                  onDismiss: () => cubit.decline(like.likeId),
                                ),
                              );
                            },
                          ),
                        ),
                        if (state.loadingMore)
                          const SliverPadding(
                            padding: EdgeInsets.only(bottom: 24),
                            sliver: SliverToBoxAdapter(
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          ),
                      ],
                    },
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Centered empty / error text, with a Retry button for errors.
class _Message extends StatelessWidget {
  const _Message({required this.text, this.onRetry});

  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: AppTextStyles.likesName.copyWith(color: colors.textMuted),
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

/// "Likes" title (centered in the space left of the bell, per Figma) and
/// the notifications bell.
class _Header extends StatelessWidget {
  const _Header({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: Text(
                AppStrings.likesTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.likesName.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const NotificationBell(),
          ],
        ),
      ),
    );
  }
}
