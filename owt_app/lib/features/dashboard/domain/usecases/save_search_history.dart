import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../repositories/clubs_repository.dart';

/// Records a tapped search result in recent searches.
class SaveSearchHistory implements UseCase<void, SaveSearchHistoryParams> {
  final ClubsRepository repository;

  const SaveSearchHistory(this.repository);

  @override
  Future<void> call(SaveSearchHistoryParams params) =>
      repository.saveSearchHistory(clubId: params.clubId, query: params.query);
}

class SaveSearchHistoryParams extends Equatable {
  final String clubId;

  /// The text the user had typed; null or empty when tapped from Recent.
  final String? query;

  const SaveSearchHistoryParams({required this.clubId, this.query});

  @override
  List<Object?> get props => [clubId, query];
}
