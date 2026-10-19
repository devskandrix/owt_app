import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchDeckState extends Equatable {
  /// Which of the available photos leads the profile. See [MatchPage] for
  /// why this exists (temporary testing aid).
  final int leadIndex;

  /// Profiles swiped so far this session.
  final int swipeCount;

  /// Whether the current user already has an active Going Tonight badge.
  final bool hasGoingTonightBadge;

  /// True while the Going Tonight promo card is showing in place of a
  /// profile.
  final bool showBadgePromo;

  const MatchDeckState({
    this.leadIndex = 0,
    this.swipeCount = 0,
    this.hasGoingTonightBadge = false,
    this.showBadgePromo = false,
  });

  MatchDeckState copyWith({
    int? leadIndex,
    int? swipeCount,
    bool? hasGoingTonightBadge,
    bool? showBadgePromo,
  }) {
    return MatchDeckState(
      leadIndex: leadIndex ?? this.leadIndex,
      swipeCount: swipeCount ?? this.swipeCount,
      hasGoingTonightBadge: hasGoingTonightBadge ?? this.hasGoingTonightBadge,
      showBadgePromo: showBadgePromo ?? this.showBadgePromo,
    );
  }

  @override
  List<Object?> get props => [
    leadIndex,
    swipeCount,
    hasGoingTonightBadge,
    showBadgePromo,
  ];
}

/// Drives the match deck: advances to the next profile on each swipe and,
/// for users without a Going Tonight badge, slots the badge promo card in
/// after every [promoInterval] swipes.
class MatchDeckCubit extends Cubit<MatchDeckState> {
  // TODO: seed hasGoingTonightBadge from the user's profile once the API
  // returns it.
  MatchDeckCubit({required this.photoCount, bool hasGoingTonightBadge = false})
    : super(MatchDeckState(hasGoingTonightBadge: hasGoingTonightBadge));

  final int photoCount;

  static const int promoInterval = 4;

  void advance() {
    final swipeCount = state.swipeCount + 1;
    emit(
      state.copyWith(
        leadIndex: (state.leadIndex + 1) % photoCount,
        swipeCount: swipeCount,
        showBadgePromo:
            !state.hasGoingTonightBadge && swipeCount % promoInterval == 0,
      ),
    );
  }

  void dismissBadgePromo() => emit(state.copyWith(showBadgePromo: false));

  /// Called once verification succeeds — stops the promo for this session.
  void badgeActivated() => emit(
    state.copyWith(hasGoingTonightBadge: true, showBadgePromo: false),
  );
}
