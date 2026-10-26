import 'package:equatable/equatable.dart';

/// One like the user received: who sent it, and the club they were at.
/// `GET /matchmaking/likes/received` groups likes by person; each
/// (person, club) pair becomes its own [ReceivedLike], since that's the
/// unit accept / decline act on.
class ReceivedLike extends Equatable {
  /// Pass to accept / decline.
  final String likeId;
  final String userId;
  final String name;

  /// e.g. "Mumbai, India"; null when the profile has no location.
  final String? location;
  final List<String> photoUrls;
  final List<String> interests;
  final String? bio;

  final String clubId;
  final String clubName;
  final String? clubImageUrl;
  final DateTime? likedAt;

  const ReceivedLike({
    required this.likeId,
    required this.userId,
    required this.name,
    required this.photoUrls,
    required this.interests,
    required this.clubId,
    required this.clubName,
    this.location,
    this.bio,
    this.clubImageUrl,
    this.likedAt,
  });

  String? get avatarUrl => photoUrls.isEmpty ? null : photoUrls.first;

  @override
  List<Object?> get props => [
    likeId,
    userId,
    name,
    location,
    photoUrls,
    interests,
    bio,
    clubId,
    clubName,
    clubImageUrl,
    likedAt,
  ];
}

/// One page of received likes.
class ReceivedLikesPage extends Equatable {
  final List<ReceivedLike> likes;

  /// `meta.total`: everyone who liked the user, across all pages.
  final int total;
  final int page;
  final int totalPages;

  const ReceivedLikesPage({
    required this.likes,
    required this.total,
    required this.page,
    required this.totalPages,
  });

  bool get hasMore => page < totalPages;

  @override
  List<Object?> get props => [likes, total, page, totalPages];
}

/// Result of `POST /matchmaking/likes/:likeId/accept`.
class AcceptLikeResult extends Equatable {
  final bool matched;
  final String? matchId;

  const AcceptLikeResult({required this.matched, this.matchId});

  @override
  List<Object?> get props => [matched, matchId];
}
