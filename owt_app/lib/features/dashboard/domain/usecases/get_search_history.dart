import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/search_history_item.dart';
import '../repositories/clubs_repository.dart';

class GetSearchHistory
    implements UseCase<List<SearchHistoryItem>, GetSearchHistoryParams> {
  final ClubsRepository repository;

  const GetSearchHistory(this.repository);

  @override
  Future<List<SearchHistoryItem>> call(GetSearchHistoryParams params) =>
      repository.getSearchHistory(limit: params.limit);
}

class GetSearchHistoryParams extends Equatable {
  final int? limit;

  const GetSearchHistoryParams({this.limit});

  @override
  List<Object?> get props => [limit];
}
