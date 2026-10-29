import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../matchmaking/domain/entities/discover_profile.dart';
import '../../../matchmaking/domain/entities/discover_queue.dart';
import '../../../matchmaking/domain/entities/like_outcome.dart';
import '../../../matchmaking/domain/usecases/discover_profiles.dart';
import '../../../matchmaking/domain/usecases/join_match_queue.dart';
import '../../../matchmaking/domain/usecases/like_profile.dart';
import '../../../matchmaking/domain/usecases/pass_profile.dart';

enum MatchDeckStatus {
  loading,

  /// Showing [MatchDeckState.current] (or the promo card in its place).
  ready,

  /// Nobody left in the queue.
  empty,
  failure,
}

class MatchDeckState extends Equatable {
  final MatchDeckStatus status;
  final List<DiscoverProfile> profiles;
  final int index;

  /// Profiles swiped so far — also keys each profile's scroll view so the
  /// next one opens at the top.
  final int swipeCount;

  /// Whether the user holds the Going Tonight badge at this club.
  final bool isVerified;

  /// `meta.verifiedInterval` from discover: without the badge, the promo
  /// card shows after every this-many swipes.
  final int? verifiedInterval;

  /// True while the Going Tonight promo card is showing in place of the
  /// next profile.
  final bool showBadgePromo;
  final String? errorMessage;

  const MatchDeckState({
    this.status = MatchDeckStatus.loading,
    this.profiles = const [],
    this.index = 0,
    this.swipeCount = 0,
    this.isVerified = false,
    this.verifiedInterval,
    this.showBadgePromo = false,
    this.errorMessage,
  });

  DiscoverProfile? get current =>
      index < profiles.length ? profiles[index] : null;

  MatchDeckState copyWith({
    MatchDeckStatus? status,
    List<DiscoverProfile>? profiles,
    int? index,
    int? swipeCount,
    bool? isVerified,
    int? verifiedInterval,
    bool? showBadgePromo,
    String? errorMessage,
  }) {
    return MatchDeckState(
      status: status ?? this.status,
      profiles: profiles ?? this.profiles,
      index: index ?? this.index,
      swipeCount: swipeCount ?? this.swipeCount,
      isVerified: isVerified ?? this.isVerified,
      verifiedInterval: verifiedInterval ?? this.verifiedInterval,
      showBadgePromo: showBadgePromo ?? this.showBadgePromo,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    profiles,
    index,
    swipeCount,
    isVerified,
    verifiedInterval,
    showBadgePromo,
    errorMessage,
  ];
}

/// Result of a right swipe, for the page to surface.
sealed class LikeResult {
  const LikeResult();
}

class LikeSent extends LikeResult {
  const LikeSent();
}

class LikeMatched extends LikeResult {
  const LikeMatched(this.name);
  final String name;
}

/// Already matched with this person: the server posted a note into the
/// existing chat instead. No match animation, no navigation.
class LikeAlreadyMatched extends LikeResult {
  const LikeAlreadyMatched();
}

class LikeFailed extends LikeResult {
  const LikeFailed(this.message);
  final String message;
}

/// A club's match-making deck.
///
/// Opening it: joins the club's queue with `POST /matchmaking/queue`,
/// then loads it from `GET /matchmaking/discover`, whose
/// `meta.isCheckedInAtClub` says whether the user holds the badge here. Without the badge, the Going
/// Tonight promo card replaces the next profile every `verifiedInterval`
/// swipes. Right swipes send `POST /matchmaking/likes`; left swipes send
/// `POST /matchmaking/pass`.
class MatchDeckCubit extends Cubit<MatchDeckState> {
  MatchDeckCubit(
    this.clubId,
    this._discoverProfiles,
    this._likeProfile,
    this._passProfile,
    this._joinQueue,
  ) : super(const MatchDeckState());

  final String clubId;
  final DiscoverProfiles _discoverProfiles;
  final LikeProfile _likeProfile;
  final PassProfile _passProfile;
  final JoinMatchQueue _joinQueue;

  static const int _queueSize = 20;

  /// Set once `POST /matchmaking/queue` succeeds, so reloads don't rejoin.
  bool _joinedQueue = false;

  /// Loads the deck — on open, and from the empty / error states. Joins
  /// the club's queue first (once per screen visit).
  Future<void> load() async {
    emit(state.copyWith(status: MatchDeckStatus.loading));
    try {
      if (!_joinedQueue) {
        await _joinQueue(JoinMatchQueueParams(clubId: clubId));
        _joinedQueue = true;
      }
      final queue = await _fetchQueue();
      if (isClosed) return;
      emit(
        state.copyWith(
          status: queue.profiles.isEmpty
              ? MatchDeckStatus.empty
              : MatchDeckStatus.ready,
          profiles: queue.profiles,
          index: 0,
          isVerified: queue.isCheckedInAtClub,
          verifiedInterval: queue.verifiedInterval,
          showBadgePromo: false,
        ),
      );
    } on Failure catch (f) {
      _fail(f.message);
    } catch (_) {
      _fail(AppStrings.somethingWentWrong);
    }
  }

  /// After a successful check-in: re-asks discover whether the badge now
  /// covers this club (`meta.isCheckedInAtClub`). Keeps the current queue
  /// and position either way. Returns
  /// whether this club is covered (the server checks the user in wherever
  /// they actually are, which may be a different club).
  Future<bool> refreshBadge() async {
    try {
      final verified = (await _fetchQueue()).isCheckedInAtClub;
      if (!isClosed) {
        emit(
          state.copyWith(
            isVerified: verified,
            showBadgePromo: verified ? false : null,
          ),
        );
      }
      return verified;
    } catch (_) {
      return false;
    }
  }

  /// Moves on immediately, then sends the pass in the background. A
  /// failed pass isn't shown: the person may just come up again later.
  Future<void> swipeLeft() async {
    final profile = state.current;
    _advance();
    if (profile == null) return;
    try {
      await _passProfile(
        LikeProfileParams(receiverId: profile.id, clubId: clubId),
      );
    } catch (_) {}
  }

  /// Moves on immediately, then sends the like in the background.
  Future<LikeResult> swipeRight() async {
    final profile = state.current;
    _advance();
    if (profile == null) return const LikeSent();
    try {
      final outcome = await _likeProfile(
        LikeProfileParams(receiverId: profile.id, clubId: clubId),
      );
      return switch (outcome) {
        LikeOutcome.matched => LikeMatched(profile.fullName),
        LikeOutcome.alreadyMatched => const LikeAlreadyMatched(),
        LikeOutcome.sent => const LikeSent(),
      };
    } on Failure catch (f) {
      return LikeFailed(f.message);
    } catch (_) {
      return const LikeFailed(AppStrings.somethingWentWrong);
    }
  }

  /// Promo card's close (X): carries on to the next profile.
  void dismissBadgePromo() => emit(state.copyWith(showBadgePromo: false));

  Future<DiscoverQueue> _fetchQueue() => _discoverProfiles(
    DiscoverProfilesParams(clubId: clubId, limit: _queueSize),
  );

  void _advance() {
    final index = state.index + 1;
    final swipeCount = state.swipeCount + 1;
    final interval = state.verifiedInterval;
    final hasNext = index < state.profiles.length;
    emit(
      state.copyWith(
        index: index,
        swipeCount: swipeCount,
        status: hasNext ? MatchDeckStatus.ready : MatchDeckStatus.empty,
        showBadgePromo:
            hasNext &&
            !state.isVerified &&
            interval != null &&
            interval > 0 &&
            swipeCount % interval == 0,
      ),
    );
  }

  void _fail(String message) {
    if (isClosed) return;
    emit(
      state.copyWith(status: MatchDeckStatus.failure, errorMessage: message),
    );
  }
}
