import '../../../../core/usecase/usecase.dart';
import '../../../profile/domain/entities/my_profile.dart';
import '../repositories/friends_repository.dart';

/// A matched person's profile, by `matchId`.
class GetFriendProfile implements UseCase<MyProfile, String> {
  final FriendsRepository repository;

  const GetFriendProfile(this.repository);

  @override
  Future<MyProfile> call(String matchId) =>
      repository.getFriendProfile(matchId);
}
