import '../../../../core/usecase/usecase.dart';
import '../entities/going_tonight_badge.dart';
import '../repositories/matchmaking_repository.dart';

class GetActiveGoingTonightBadges
    implements UseCase<List<GoingTonightBadge>, NoParams> {
  final MatchmakingRepository repository;

  const GetActiveGoingTonightBadges(this.repository);

  @override
  Future<List<GoingTonightBadge>> call(NoParams params) =>
      repository.getActiveBadges();
}
