import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../match/presentation/widgets/match_action_buttons.dart';
import '../../../match/presentation/widgets/match_card.dart';
import '../../../match/presentation/widgets/match_header.dart';
import '../../../match/presentation/widgets/swipeable_card.dart';
import '../cubit/likes_cubit.dart';
import '../cubit/likes_state.dart';
import '../widgets/likes_avatars.dart';
import '../widgets/likes_summary_card.dart';

class UserDetailArgs {
  const UserDetailArgs({required this.cubit, required this.startLikeId});

  /// The Likes screen's cubit — decisions here update its list directly.
  final LikesCubit cubit;

  /// The like tapped on the Likes screen; the deck starts here.
  final String startLikeId;
}

/// Deck of pending requests, opened from a Likes row: a pinned "Pending
/// Request" summary, the current person's scrollable profile, and X /
/// heart buttons — or swipe left / right, exactly like the match screen —
/// to reject or accept. Each decision moves on to the next pending
/// request; once none are left, it returns to Likes. Fixed dark like the
/// match screen, since it's the same full-bleed photo profile.
class UserDetailPage extends StatelessWidget {
  const UserDetailPage({super.key, required this.args});

  final UserDetailArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: args.cubit,
      child: _UserDetailView(startLikeId: args.startLikeId),
    );
  }
}

class _UserDetailView extends StatefulWidget {
  const _UserDetailView({required this.startLikeId});

  final String startLikeId;

  @override
  State<_UserDetailView> createState() => _UserDetailViewState();
}

class _UserDetailViewState extends State<_UserDetailView> {
  late String _currentId = widget.startLikeId;

  /// Replaced for each person, so the next profile starts as a fresh,
  /// centered card scrolled to the top.
  GlobalKey<SwipeableCardState> _cardKey = GlobalKey();

  static const Color _background = Color(0xFF0A0B0D);

  /// Applies the decision for the current person, then shows the next
  /// pending request after them (wrapping to the start of the list), or
  /// returns to Likes when none are left.
  void _decide({required bool accepted}) {
    final cubit = context.read<LikesCubit>();
    final pending = cubit.state.pending;
    final index = pending.indexWhere((like) => like.likeId == _currentId);
    final rest = [
      ...pending.skip(index + 1),
      ...pending.take(index < 0 ? 0 : index),
    ];

    // Fire and forget: failures surface as a notice from the Likes
    // screen, which owns the cubit.
    accepted ? cubit.accept(_currentId) : cubit.decline(_currentId);

    if (rest.isEmpty) {
      Navigator.of(context).maybePop();
      return;
    }
    setState(() {
      _currentId = rest.first.likeId;
      _cardKey = GlobalKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: Column(
          children: [
            MatchHeader(
              onBack: () => Navigator.of(context).maybePop(),
              showActions: false,
            ),
            BlocBuilder<LikesCubit, LikesState>(
              builder: (context, state) {
                final previews = likePreviews(state.pending, count: 2);
                final extra = state.totalLikes - previews.length;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: LikesSummaryCard(
                    title: AppStrings.pendingRequestTitle,
                    subtitle: AppStrings.pendingRequestSubtitle,
                    previews: previews,
                    extra: extra > 0 ? extra : 0,
                    bordered: false,
                    firstAvatarSize: 44,
                    textColor: Colors.white,
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<LikesCubit, LikesState>(
                builder: (context, state) {
                  final like = state.pending
                      .where((like) => like.likeId == _currentId)
                      .firstOrNull;
                  // Already decided (e.g. the screen is closing).
                  if (like == null) return const SizedBox.shrink();
                  return Stack(
                    children: [
                      SwipeableCard(
                        key: _cardKey,
                        onSwipeLeft: () => _decide(accepted: false),
                        onSwipeRight: () => _decide(accepted: true),
                        // The next profile gets a fresh card instead.
                        resetAfterSwipe: false,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 96),
                          child: MatchCard(
                            name: like.name,
                            photos: [
                              for (final url in like.photoUrls)
                                NetworkImage(url),
                            ],
                            interests: like.interests,
                            aboutMe: like.bio,
                            showGoingTonight: false,
                            onGoingTonightTap: () {},
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 20,
                        child: MatchActionButtons(
                          onCancel: () => _cardKey.currentState?.swipeLeft(),
                          onLike: () => _cardKey.currentState?.swipeRight(),
                        ),
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
