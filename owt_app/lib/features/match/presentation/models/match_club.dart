import 'package:equatable/equatable.dart';

/// The club a match-making screen is for — passed as the route's `extra`
/// from a club card on Home.
class MatchClub extends Equatable {
  final String id;
  final String name;
  final String? city;

  /// The club's `coverImage`.
  final String? coverImage;

  /// The user already holds the Going Tonight badge here (the club's
  /// `isUserVerified`), so the swipe queue can load straight away.
  final bool isUserVerified;

  /// People going tonight (the club's `goingTonightNow`).
  final int goingTonightNow;

  /// The club's `viewCount`.
  final int viewCount;

  const MatchClub({
    required this.id,
    required this.name,
    this.city,
    this.coverImage,
    this.isUserVerified = false,
    this.goingTonightNow = 0,
    this.viewCount = 0,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    city,
    coverImage,
    isUserVerified,
    goingTonightNow,
    viewCount,
  ];
}
