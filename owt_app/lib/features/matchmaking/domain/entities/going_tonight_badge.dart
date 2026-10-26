import 'package:equatable/equatable.dart';

/// The user's Going Tonight badge at one club.
class GoingTonightBadge extends Equatable {
  final String clubId;
  final String? clubName;
  final DateTime? expiresAt;

  const GoingTonightBadge({
    required this.clubId,
    this.clubName,
    this.expiresAt,
  });

  @override
  List<Object?> get props => [clubId, clubName, expiresAt];
}
