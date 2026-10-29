import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/top_notice.dart';
import '../../../going_tonight/presentation/going_tonight_flow.dart';
import '../../../going_tonight/presentation/widgets/going_tonight_badge_card.dart';
import '../../../matchmaking/domain/entities/discover_profile.dart';
import '../cubit/match_deck_cubit.dart';
import '../models/match_club.dart';
import '../widgets/match_action_buttons.dart';
import '../widgets/match_card.dart';
import '../widgets/match_header.dart';
import '../widgets/match_venue_chip.dart';
import '../widgets/swipeable_card.dart';

/// A club's "Final match making" screen: one scrollable profile at a time
/// from the club's queue. Without the club's Going Tonight badge, the
/// "This is Going Tonight" sheet opens over the first profile, and the
/// badge promo card replaces the next profile every `verifiedInterval`
/// swipes. The user swipes each profile left (pass) or right (like), with
/// two fixed buttons that trigger the exact same action as the equivalent
/// swipe. Fixed dark styling throughout — no light Figma
/// frame exists for this full-bleed photo screen.
class MatchPage extends StatelessWidget {
  const MatchPage({super.key, required this.club});

  /// Null if opened without a club (e.g. a static demo card).
  final MatchClub? club;

  static const Color _background = Color(0xFF0A0B0D);

  @override
  Widget build(BuildContext context) {
    final club = this.club;
    if (club == null) {
      return Scaffold(
        backgroundColor: _background,
        body: SafeArea(
          child: Column(
            children: [
              MatchHeader(onBack: () => Navigator.of(context).maybePop()),
              const Expanded(
                child: _StatusMessage(
                  title: AppStrings.matchLoadFailedTitle,
                  message: AppStrings.somethingWentWrong,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return BlocProvider(
      create: (_) => MatchDeckCubit(club.id, sl(), sl(), sl(), sl())..load(),
      child: _MatchView(club: club),
    );
  }
}

class _MatchView extends StatefulWidget {
  const _MatchView({required this.club});

  final MatchClub club;

  @override
  State<_MatchView> createState() => _MatchViewState();
}

class _MatchViewState extends State<_MatchView> {
  final _cardKey = GlobalKey<SwipeableCardState>();

  MatchClub get _club => widget.club;

  /// Set once the sheet has opened on entry, so it doesn't reopen when the
  /// deck reloads.
  bool _promptedOnEntry = false;

  /// Entering without this club's badge opens the sheet over the first
  /// profile once the deck has loaded.
  void _promptOnEntry(MatchDeckState deck) {
    if (_promptedOnEntry || deck.isVerified) return;
    _promptedOnEntry = true;
    _startGoingTonight();
  }

  /// From a profile's "Going Tonight" pill, or on entering without the
  /// badge: info sheet, then verification.
  Future<void> _startGoingTonight() => _handleOutcome(
    showGoingTonightFlow(
      context,
      venueName: _club.name,
      venueCity: _club.city ?? _club.name,
      clubId: _club.id,
    ),
  );

  /// From the promo card's "Verify Mine": straight to verification.
  Future<void> _verifyFromPromo() => _handleOutcome(
    verifyGoingTonight(
      context,
      venueName: _club.name,
      venueCity: _club.city ?? _club.name,
      clubId: _club.id,
    ),
  );

  /// After a successful check-in (`POST /matchmaking/going-tonight`):
  /// "Start Matching" reloads the deck from `GET /matchmaking/discover`;
  /// "Maybe later" only re-checks the badge and keeps the current queue.
  /// Either way discover's `meta.isCheckedInAtClub` says whether the badge
  /// covers this club — the server checks the user in wherever they
  /// actually are, which may be a different club.
  Future<void> _handleOutcome(Future<GoingTonightOutcome?> flow) async {
    final outcome = await flow;
    if (outcome == null || !mounted) return;
    final cubit = context.read<MatchDeckCubit>();
    final bool verifiedHere;
    if (outcome == GoingTonightOutcome.startMatching) {
      await cubit.load();
      verifiedHere = cubit.state.isVerified;
      // A failed reload already shows the error state with Retry.
      if (cubit.state.status == MatchDeckStatus.failure) return;
    } else {
      verifiedHere = await cubit.refreshBadge();
    }
    if (!mounted) return;
    if (!verifiedHere) {
      TopNotice.showError(context, AppStrings.matchBadgeAtOtherClub);
    } else if (outcome == GoingTonightOutcome.maybeLater) {
      Navigator.of(context).maybePop();
    }
  }

  Future<void> _onSwipeRight() async {
    final result = await context.read<MatchDeckCubit>().swipeRight();
    if (!mounted) return;
    switch (result) {
      case LikeMatched(:final name):
        TopNotice.showSuccess(context, AppStrings.matchItsAMatch(name));
      case LikeAlreadyMatched():
        TopNotice.showSuccess(context, AppStrings.matchAlreadyMatched);
      case LikeFailed(:final message):
        TopNotice.showError(context, message);
      case LikeSent():
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MatchPage._background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MatchHeader(onBack: () => Navigator.of(context).maybePop()),
            Expanded(
              child: BlocConsumer<MatchDeckCubit, MatchDeckState>(
                listenWhen: (previous, current) =>
                    previous.status == MatchDeckStatus.loading &&
                    current.status != MatchDeckStatus.loading,
                listener: (context, deck) => _promptOnEntry(deck),
                builder: (context, deck) {
                  final cubit = context.read<MatchDeckCubit>();
                  return switch (deck.status) {
                    MatchDeckStatus.loading => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    MatchDeckStatus.empty => _StatusMessage(
                      title: AppStrings.matchQueueEmptyTitle,
                      message: AppStrings.matchQueueEmptyMessage,
                      onRetry: cubit.load,
                    ),
                    MatchDeckStatus.failure => _StatusMessage(
                      title: AppStrings.matchLoadFailedTitle,
                      message:
                          deck.errorMessage ?? AppStrings.somethingWentWrong,
                      onRetry: cubit.load,
                    ),
                    MatchDeckStatus.ready when deck.showBadgePromo => Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: MatchVenueChip(
                            name: _club.name,
                            imageUrl: _club.coverImage,
                            goingTonightNow: _club.goingTonightNow,
                            viewCount: _club.viewCount,
                          ),
                        ),
                        Expanded(
                          child: GoingTonightBadgeCard(
                            onVerify: _verifyFromPromo,
                            onClose: cubit.dismissBadgePromo,
                          ),
                        ),
                      ],
                    ),
                    MatchDeckStatus.ready => _buildDeck(deck, deck.current!),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeck(MatchDeckState deck, DiscoverProfile profile) {
    final cubit = context.read<MatchDeckCubit>();
    return Stack(
      children: [
        SwipeableCard(
          key: _cardKey,
          onSwipeLeft: cubit.swipeLeft,
          onSwipeRight: _onSwipeRight,
          child: SingleChildScrollView(
            // A new key per profile gives each one a fresh scroll
            // position, so it opens at the top instead of where the last
            // profile was left.
            key: ValueKey(deck.swipeCount),
            padding: const EdgeInsets.only(bottom: 96),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: MatchVenueChip(
                    name: _club.name,
                    // Photos come primary-first, so this is the
                    // `isPrimary` one.
                    imageUrl: profile.photoUrls.isNotEmpty
                        ? profile.photoUrls.first
                        : _club.coverImage,
                    goingTonightNow: _club.goingTonightNow,
                    viewCount: _club.viewCount,
                  ),
                ),
                const SizedBox(height: 12),
                MatchCard(
                  name: profile.fullName,
                  photos: [
                    for (final url in profile.photoUrls) NetworkImage(url),
                  ],
                  interests: profile.interests,
                  aboutMe: profile.bio,
                  showGoingTonight: profile.isGoingTonight,
                  onGoingTonightTap: _startGoingTonight,
                ),
              ],
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
  }
}

/// Centered title + message with an optional retry, for the empty and
/// error states.
class _StatusMessage extends StatelessWidget {
  const _StatusMessage({
    required this.title,
    required this.message,
    this.onRetry,
  });

  final String title;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.goingTonightTitle.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTextStyles.goingTonightBody,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 28),
            SizedBox(
              width: 180,
              child: GradientButton(
                label: AppStrings.retryLabel,
                onPressed: onRetry!,
              ),
            ),
          ],
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
