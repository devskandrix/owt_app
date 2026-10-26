import '../../../../core/usecase/usecase.dart';
import '../entities/friend.dart';
import '../repositories/friends_repository.dart';

class GetFriends implements UseCase<List<Friend>, NoParams> {
  final FriendsRepository repository;

  const GetFriends(this.repository);

  @override
  Future<List<Friend>> call(NoParams params) => repository.getFriends();
}
