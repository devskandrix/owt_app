import '../../../../core/usecase/usecase.dart';
import '../repositories/matchmaking_repository.dart';

/// Blocks a user by id. The server also removes any match and likes
/// between the two.
class BlockUser implements UseCase<void, String> {
  final MatchmakingRepository repository;

  const BlockUser(this.repository);

  @override
  Future<void> call(String userId) => repository.blockUser(userId);
}
