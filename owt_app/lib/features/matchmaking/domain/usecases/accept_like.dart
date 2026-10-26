import '../../../../core/usecase/usecase.dart';
import '../entities/received_like.dart';
import '../repositories/matchmaking_repository.dart';

/// Accepts a received like by its `likeId`.
class AcceptLike implements UseCase<AcceptLikeResult, String> {
  final MatchmakingRepository repository;

  const AcceptLike(this.repository);

  @override
  Future<AcceptLikeResult> call(String likeId) => repository.acceptLike(likeId);
}
