import '../../../../core/usecase/usecase.dart';
import '../repositories/clubs_repository.dart';

/// Clears every recent search ("Clear All").
class ClearSearchHistory implements UseCase<void, NoParams> {
  final ClubsRepository repository;

  const ClearSearchHistory(this.repository);

  @override
  Future<void> call(NoParams params) => repository.clearSearchHistory();
}
