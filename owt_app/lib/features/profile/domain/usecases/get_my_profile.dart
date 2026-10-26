import '../../../../core/usecase/usecase.dart';
import '../entities/my_profile.dart';
import '../repositories/profile_repository.dart';

class GetMyProfile implements UseCase<MyProfile, NoParams> {
  final ProfileRepository repository;

  const GetMyProfile(this.repository);

  @override
  Future<MyProfile> call(NoParams params) => repository.getMyProfile();
}
