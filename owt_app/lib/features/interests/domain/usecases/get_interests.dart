import '../../../../core/usecase/usecase.dart';
import '../entities/interest_category.dart';
import '../repositories/interests_repository.dart';

class GetInterests implements UseCase<List<InterestCategory>, NoParams> {
  final InterestsRepository repository;

  const GetInterests(this.repository);

  @override
  Future<List<InterestCategory>> call(NoParams params) {
    return repository.getInterests();
  }
}
