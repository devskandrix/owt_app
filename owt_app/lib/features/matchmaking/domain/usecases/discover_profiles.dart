import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/discover_queue.dart';
import '../repositories/matchmaking_repository.dart';

class DiscoverProfiles
    implements UseCase<DiscoverQueue, DiscoverProfilesParams> {
  final MatchmakingRepository repository;

  const DiscoverProfiles(this.repository);

  @override
  Future<DiscoverQueue> call(DiscoverProfilesParams params) =>
      repository.discover(clubId: params.clubId, limit: params.limit);
}

class DiscoverProfilesParams extends Equatable {
  final String clubId;
  final int? limit;

  const DiscoverProfilesParams({required this.clubId, this.limit});

  @override
  List<Object?> get props => [clubId, limit];
}
