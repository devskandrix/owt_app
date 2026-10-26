import '../../../../core/usecase/usecase.dart';
import '../repositories/matchmaking_repository.dart';

/// Declines a received like by its `likeId`.
class DeclineLike implements UseCase<void, String> {
  final MatchmakingRepository repository;

  const DeclineLike(this.repository);

  @override
  Future<void> call(String likeId) => repository.declineLike(likeId);
}
