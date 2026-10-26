import '../../../../core/network/media_url.dart';
import '../../domain/entities/received_like.dart';
import 'discover_profile_model.dart';

/// Parses one `{ user, clubs: [{ id, name, likeId }], likedAt }` entry of
/// `GET /matchmaking/likes/received` into one [ReceivedLike] per club.
/// The public profile is read with [DiscoverProfileModel]'s lenient
/// parsing (photos, interests, bio); clubs without a `likeId` are skipped.
class ReceivedLikeModel {
  static List<ReceivedLike> fromJson(Map<String, dynamic> json) {
    final user = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : const <String, dynamic>{};
    final profile = DiscoverProfileModel.fromJson({'user': user});
    final likedAt = json['likedAt'];
    final clubs = json['clubs'];
    if (clubs is! List) return const [];
    return [
      for (final club in clubs.whereType<Map<String, dynamic>>())
        if (club['likeId'] != null)
          ReceivedLike(
            likeId: club['likeId'].toString(),
            userId: profile.id,
            name: profile.fullName,
            location: _location(user),
            photoUrls: profile.photoUrls,
            interests: profile.interests,
            bio: profile.bio,
            clubId: club['id'].toString(),
            clubName: (club['name'] as String?) ?? '',
            clubImageUrl: _mediaUrl(
              club['coverImage'] ?? club['image'] ?? club['imageUrl'],
            ),
            likedAt: likedAt is String ? DateTime.tryParse(likedAt) : null,
          ),
    ];
  }

  /// "City, Country" from whichever location fields the profile has.
  static String? _location(Map<String, dynamic> user) {
    final location = _string(user['location']);
    if (location != null) return location;
    final parts = [
      _string(user['city']),
      _string(user['country']),
    ].whereType<String>();
    return parts.isEmpty ? null : parts.join(', ');
  }

  static String? _mediaUrl(dynamic value) {
    final url = _string(value);
    return url == null ? null : resolveMediaUrl(url);
  }

  static String? _string(dynamic value) =>
      value is String && value.trim().isNotEmpty ? value.trim() : null;
}
