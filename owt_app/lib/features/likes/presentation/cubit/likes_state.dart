import 'package:equatable/equatable.dart';

import '../../domain/entities/liked_user.dart';

class LikesState extends Equatable {
  /// People who liked the user and are still awaiting Confirm / dismiss.
  final List<LikedUser> likes;

  /// Total likes, including ones not listed (drives the "+N" badge).
  final int totalLikes;

  /// Ids confirmed this session — their row shows the "It’s Match" banner
  /// until it's dismissed.
  final Set<String> matchedIds;

  const LikesState({
    this.likes = const [],
    this.totalLikes = 0,
    this.matchedIds = const {},
  });

  LikesState copyWith({
    List<LikedUser>? likes,
    int? totalLikes,
    Set<String>? matchedIds,
  }) {
    return LikesState(
      likes: likes ?? this.likes,
      totalLikes: totalLikes ?? this.totalLikes,
      matchedIds: matchedIds ?? this.matchedIds,
    );
  }

  @override
  List<Object?> get props => [likes, totalLikes, matchedIds];
}
