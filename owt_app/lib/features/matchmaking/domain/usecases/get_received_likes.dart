import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/received_like.dart';
import '../repositories/matchmaking_repository.dart';

class GetReceivedLikes
    implements UseCase<ReceivedLikesPage, GetReceivedLikesParams> {
  final MatchmakingRepository repository;

  const GetReceivedLikes(this.repository);

  @override
  Future<ReceivedLikesPage> call(GetReceivedLikesParams params) =>
      repository.getReceivedLikes(page: params.page, limit: params.limit);
}

class GetReceivedLikesParams extends Equatable {
  final int page;
  final int limit;

  const GetReceivedLikesParams({this.page = 1, this.limit = 20});

  @override
  List<Object?> get props => [page, limit];
}
