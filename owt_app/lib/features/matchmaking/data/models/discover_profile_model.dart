import '../../../../core/network/media_url.dart';
import '../../domain/entities/discover_profile.dart';

/// Parses one `{ isGoingTonight, user }` entry of
/// `GET /matchmaking/discover`. The user object's shape beyond `id` /
/// `fullName` isn't documented yet, so photos, interests and bio are read
/// leniently and simply left empty when absent.
class DiscoverProfileModel {
  static DiscoverProfile fromJson(Map<String, dynamic> json) {
    final user = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : const <String, dynamic>{};
    return DiscoverProfile(
      id: user['id'].toString(),
      fullName: _fullName(user),
      photoUrls: _photoUrls(user['photos']),
      interests: _interestNames(user['interests']),
      bio: (user['bio'] ?? user['about']) as String?,
      isGoingTonight: json['isGoingTonight'] == true,
    );
  }

  static String _fullName(Map<String, dynamic> user) {
    final full = user['fullName'];
    if (full is String && full.trim().isNotEmpty) return full.trim();
    return [
      user['firstName'],
      user['lastName'],
    ].whereType<String>().where((part) => part.isNotEmpty).join(' ');
  }

  /// Photos may be plain URLs or photo records (`{ imageUrl, displayOrder,
  /// isPrimary }`, as on `/users/me`) — primary first, then by order.
  static List<String> _photoUrls(dynamic value) {
    if (value is! List) return const [];
    final records = value.whereType<Map<String, dynamic>>().toList()
      ..sort((a, b) {
        if (a['isPrimary'] == true) return -1;
        if (b['isPrimary'] == true) return 1;
        return ((a['displayOrder'] as num?) ?? 0).compareTo(
          (b['displayOrder'] as num?) ?? 0,
        );
      });
    return [
      ...value.whereType<String>(),
      for (final record in records)
        if ((record['imageUrl'] ?? record['url']) case final String url) url,
    ].map(resolveMediaUrl).toList();
  }

  /// Interests may be names, `{ name }`, or join rows `{ interest: { name } }`.
  static List<String> _interestNames(dynamic value) {
    if (value is! List) return const [];
    return [
      for (final item in value)
        if (item is String)
          item
        else if (item is Map<String, dynamic>)
          if ((item['name'] ??
                  (item['interest'] is Map ? item['interest']['name'] : null))
              case final String name)
            name,
    ];
  }
}
