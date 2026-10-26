import '../../../../core/network/media_url.dart';
import '../../../matchmaking/data/models/discover_profile_model.dart';
import '../../../profile/data/models/my_profile_model.dart';
import '../../domain/entities/friend.dart';

/// Parses one `GET /matches` item: `{ matchId, matchedAt, club, user }`.
/// The avatar is the user's primary photo. The location line is the
/// user's own location if they have one, otherwise the club's city and
/// country (e.g. "Surat, India"), since profiles don't include a city.
/// Items without a user are skipped.
class FriendModel {
  static Friend? fromJson(Map<String, dynamic> json) {
    final user = _map(json['user'] ?? json['otherUser'] ?? json['matchedUser']);
    if (user == null) return null;
    final profile = DiscoverProfileModel.fromJson({'user': user});
    final club = _map(json['club']);
    final matchedAt = json['matchedAt'];
    return Friend(
      matchId: (json['matchId'] ?? json['id']).toString(),
      userId: profile.id,
      name: profile.fullName,
      location: _location(user) ?? _location(club),
      avatarUrl: profile.photoUrls.isEmpty ? null : profile.photoUrls.first,
      clubName: _string(club?['name']),
      clubImageUrl: _mediaUrl(
        club?['coverImage'] ?? club?['image'] ?? club?['imageUrl'],
      ),
      matchedAt: matchedAt is String ? DateTime.tryParse(matchedAt) : null,
      profile: MyProfileModel.fromJson(user),
    );
  }

  /// "City, Country" from a user or club, or its `location` text.
  static String? _location(Map<String, dynamic>? json) {
    if (json == null) return null;
    final location = _string(json['location']);
    if (location != null) return location;
    final parts = [
      _string(json['city']),
      _string(json['country']),
    ].whereType<String>();
    return parts.isEmpty ? null : parts.join(', ');
  }

  static Map<String, dynamic>? _map(dynamic value) =>
      value is Map<String, dynamic> ? value : null;

  static String? _mediaUrl(dynamic value) {
    final url = _string(value);
    return url == null ? null : resolveMediaUrl(url);
  }

  static String? _string(dynamic value) =>
      value is String && value.trim().isNotEmpty ? value.trim() : null;
}
