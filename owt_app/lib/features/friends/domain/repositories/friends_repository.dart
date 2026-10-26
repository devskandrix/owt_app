import '../../../profile/domain/entities/my_profile.dart';
import '../entities/friend.dart';

abstract class FriendsRepository {
  /// `GET /matches`: everyone the user has matched with.
  Future<List<Friend>> getFriends();

  /// `GET /matches/:matchId`: the matched person's full profile.
  Future<MyProfile> getFriendProfile(String matchId);
}
