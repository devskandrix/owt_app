import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../gen/assets.gen.dart';
import '../../../going_tonight/presentation/going_tonight_flow.dart';
import '../../../going_tonight/presentation/widgets/going_tonight_badge_card.dart';
import '../cubit/match_deck_cubit.dart';
import '../widgets/match_action_buttons.dart';
import '../widgets/match_card.dart';
import '../widgets/match_header.dart';
import '../widgets/match_venue_chip.dart';
import '../widgets/swipeable_card.dart';

/// Full-bleed "Final match making" screen: one scrollable profile (avatar
/// row, main photo, tags, about-me, then further photos of the same
/// profile) that the user can swipe left (Cancel) or right (Like), with
/// two fixed buttons that trigger the exact same action as the equivalent
/// swipe gesture. Fixed dark styling throughout — no light Figma frame
/// exists for this screen, which (like the Trending carousel) is a
/// full-bleed photo card.
class MatchPage extends StatelessWidget {
  const MatchPage({super.key});

  // TEMPORARY (testing only): cycles which of the 3 available photos leads
  // the profile on each swipe, purely so a "next card" is visibly
  // distinguishable while trying the gesture. Remove once real per-profile
  // data exists.
  static final List<AssetGenImage> _testPhotos = [
    Assets.images.matchProfileMain,
    Assets.images.matchProfileDeck2,
    Assets.images.matchProfileDeck3,
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MatchDeckCubit(photoCount: _testPhotos.length),
      child: _MatchView(photos: _testPhotos),
    );
  }
}

class _MatchView extends StatefulWidget {
  const _MatchView({required this.photos});

  final List<AssetGenImage> photos;

  @override
  State<_MatchView> createState() => _MatchViewState();
}

class _MatchViewState extends State<_MatchView> {
  final _cardKey = GlobalKey<SwipeableCardState>();

  // TODO: pass the venue's real name and coordinates once this screen is
  // driven by club data — with coordinates, verification also checks the
  // user is within GoingTonightCubit.maxDistanceMeters of the venue.

  /// From a profile's "Going Tonight" pill: info sheet, then verification.
  Future<void> _startGoingTonight() => _handleOutcome(
    showGoingTonightFlow(
      context,
      venueName: AppStrings.matchVenueName,
      venueCity: AppStrings.matchVenueCity,
    ),
  );

  /// From the promo card's "Verify Mine": straight to verification.
  Future<void> _verifyFromPromo() => _handleOutcome(
    verifyGoingTonight(
      context,
      venueName: AppStrings.matchVenueName,
      venueCity: AppStrings.matchVenueCity,
    ),
  );

  Future<void> _handleOutcome(Future<GoingTonightOutcome?> flow) async {
    final outcome = await flow;
    if (outcome == null || !mounted) return;
    context.read<MatchDeckCubit>().badgeActivated();
    if (outcome == GoingTonightOutcome.maybeLater) {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0B0D),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MatchHeader(onBack: () => Navigator.of(context).maybePop()),
            Expanded(
              child: BlocBuilder<MatchDeckCubit, MatchDeckState>(
                builder: (context, deck) {
                  final cubit = context.read<MatchDeckCubit>();
                  if (deck.showBadgePromo) {
                    return Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: MatchVenueChip(),
                        ),
                        Expanded(
                          child: GoingTonightBadgeCard(
                            onVerify: _verifyFromPromo,
                            onClose: cubit.dismissBadgePromo,
                          ),
                        ),
                      ],
                    );
                  }

                  final leadIndex = deck.leadIndex;
                  final mainPhoto = widget.photos[leadIndex];
                  final morePhotos = [
                    for (var i = 1; i < widget.photos.length; i++)
                      widget.photos[(leadIndex + i) % widget.photos.length],
                  ];
                  final advance = cubit.advance;

                  return Stack(
                    children: [
                      SwipeableCard(
                        key: _cardKey,
                        onSwipeLeft: advance,
                        onSwipeRight: advance,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 96),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: MatchVenueChip(),
                              ),
                              const SizedBox(height: 12),
                              MatchCard(
                                mainPhoto: mainPhoto,
                                morePhotos: morePhotos,
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
