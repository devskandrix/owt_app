import '../../domain/entities/going_tonight_badge.dart';

/// Parses the badge out of either `POST /matchmaking/going-tonight`'s
/// `{ club, session, goingTonight }` or one entry of
/// `GET /matchmaking/going-tonight`'s `sessions[]`
/// (`{ clubId, club, goingTonight }`).
class GoingTonightBadgeModel {
  static GoingTonightBadge fromJson(Map<String, dynamic> json) {
    final club = _map(json['club']);
    final session = _map(json['session']);
    final goingTonight = _map(json['goingTonight']);
    final clubId = json['clubId'] ?? session?['clubId'] ?? club?['id'];
    final expiresAt = goingTonight?['expiresAt'];
    return GoingTonightBadge(
      clubId: clubId.toString(),
      clubName: club?['name'] as String?,
      expiresAt: expiresAt is String ? DateTime.tryParse(expiresAt) : null,
    );
  }

  static Map<String, dynamic>? _map(dynamic value) =>
      value is Map<String, dynamic> ? value : null;
}
