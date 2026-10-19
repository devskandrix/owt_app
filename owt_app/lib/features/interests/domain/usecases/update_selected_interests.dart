import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../repositories/interests_repository.dart';

class UpdateSelectedInterests
    implements UseCase<void, UpdateSelectedInterestsParams> {
  final InterestsRepository repository;

  const UpdateSelectedInterests(this.repository);

  @override
  Future<void> call(UpdateSelectedInterestsParams params) {
    return repository.updateSelectedInterests(params.interestIds);
  }
}

class UpdateSelectedInterestsParams extends Equatable {
  final List<String> interestIds;

  const UpdateSelectedInterestsParams(this.interestIds);

  @override
  List<Object?> get props => [interestIds];
}
