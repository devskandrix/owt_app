import 'package:equatable/equatable.dart';

import '../../../matchmaking/domain/entities/received_like.dart';

enum LikesStatus { loading, ready, failure }

class LikesState extends Equatable {
  final LikesStatus status;

  /// Received likes still on screen (pending, accepting, or matched).
  final List<ReceivedLike> likes;

  /// `meta.total` from the API: drives the "+N" badge.
  final int totalLikes;

  /// Last page loaded, and whether more pages exist.
  final int page;
  final bool hasMore;
  final bool loadingMore;

  /// Like ids accepted this session: their row shows the "It’s Match"
  /// banner until it's dismissed.
  final Set<String> matchedIds;

  /// Like ids with an accept request in flight.
  final Set<String> busyIds;

  /// Load error for the full-screen failure state.
  final String? errorMessage;

  const LikesState({
    this.status = LikesStatus.loading,
    this.likes = const [],
    this.totalLikes = 0,
    this.page = 0,
    this.hasMore = false,
    this.loadingMore = false,
    this.matchedIds = const {},
    this.busyIds = const {},
    this.errorMessage,
  });

  /// Likes still awaiting a decision: the queue User Detail swipes
  /// through.
  List<ReceivedLike> get pending => likes
      .where(
        (like) =>
            !matchedIds.contains(like.likeId) && !busyIds.contains(like.likeId),
      )
      .toList();

  LikesState copyWith({
    LikesStatus? status,
    List<ReceivedLike>? likes,
    int? totalLikes,
    int? page,
    bool? hasMore,
    bool? loadingMore,
    Set<String>? matchedIds,
    Set<String>? busyIds,
    String? errorMessage,
  }) {
    return LikesState(
      status: status ?? this.status,
      likes: likes ?? this.likes,
      totalLikes: totalLikes ?? this.totalLikes,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      loadingMore: loadingMore ?? this.loadingMore,
      matchedIds: matchedIds ?? this.matchedIds,
      busyIds: busyIds ?? this.busyIds,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    likes,
    totalLikes,
    page,
    hasMore,
    loadingMore,
    matchedIds,
    busyIds,
    errorMessage,
  ];
}

/// One-off messages for the page to show (e.g. a failed accept).
sealed class LikesNotice {
  const LikesNotice();
}

class LikesErrorNotice extends LikesNotice {
  const LikesErrorNotice(this.message);
  final String message;
}
