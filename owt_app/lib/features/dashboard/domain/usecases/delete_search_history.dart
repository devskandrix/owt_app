import '../../../../core/usecase/usecase.dart';
import '../repositories/clubs_repository.dart';

/// Removes one recent search; the param is its history id.
class DeleteSearchHistory implements UseCase<void, String> {
  final ClubsRepository repository;

  const DeleteSearchHistory(this.repository);

  @override
  Future<void> call(String historyId) =>
      repository.deleteSearchHistory(historyId);
}
