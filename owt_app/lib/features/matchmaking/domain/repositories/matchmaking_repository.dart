import '../entities/discover_queue.dart';
import '../entities/going_tonight_badge.dart';
import '../entities/received_like.dart';

abstract class MatchmakingRepository {
  /// `POST /matchmaking/going-tonight`: checks in at [clubId] from the
  /// user's [latitude]/[longitude] and returns the badge it granted. When
  /// [clubId] is null, the server picks the club from the location.
  Future<GoingTonightBadge> checkInGoingTonight({
    String? clubId,
    required double latitude,
    required double longitude,
  });

  /// `GET /matchmaking/going-tonight`: every club the user holds the badge
  /// at right now (possibly none).
  Future<List<GoingTonightBadge>> getActiveBadges();

  /// `POST /matchmaking/queue`: joins [clubId]'s match-making queue.
  Future<void> joinQueue({required String clubId});

  /// `GET /matchmaking/discover`: [clubId]'s swipe queue.
  Future<DiscoverQueue> discover({required String clubId, int? limit});

  /// `POST /matchmaking/likes`: swipe right. Returns true on a mutual match.
  Future<bool> like({required String receiverId, required String clubId});

  /// `POST /matchmaking/pass`: swipe left.
  Future<void> pass({required String receiverId, required String clubId});

  /// `GET /matchmaking/likes/received`: one page of likes the user got.
  Future<ReceivedLikesPage> getReceivedLikes({int page = 1, int limit = 20});

  /// `POST /matchmaking/likes/:likeId/accept`.
  Future<AcceptLikeResult> acceptLike(String likeId);

  /// `DELETE /matchmaking/likes/:likeId`.
  Future<void> declineLike(String likeId);

  /// `POST /users/:userId/block`.
  Future<void> blockUser(String userId);
}
