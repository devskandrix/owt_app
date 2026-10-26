import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../repositories/matchmaking_repository.dart';

/// Joins a club's match-making queue — called on entering its match screen.
class JoinMatchQueue implements UseCase<void, JoinMatchQueueParams> {
  final MatchmakingRepository repository;

  const JoinMatchQueue(this.repository);

  @override
  Future<void> call(JoinMatchQueueParams params) =>
      repository.joinQueue(clubId: params.clubId);
}

class JoinMatchQueueParams extends Equatable {
  final String clubId;

  const JoinMatchQueueParams({required this.clubId});

  @override
  List<Object?> get props => [clubId];
}
