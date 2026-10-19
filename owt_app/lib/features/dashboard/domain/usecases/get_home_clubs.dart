import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/home_clubs.dart';
import '../repositories/clubs_repository.dart';

class GetHomeClubs implements UseCase<HomeClubs, GetHomeClubsParams> {
  final ClubsRepository repository;

  const GetHomeClubs(this.repository);

  @override
  Future<HomeClubs> call(GetHomeClubsParams params) {
    return repository.getHome(
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }
}

class GetHomeClubsParams extends Equatable {
  final double? latitude;
  final double? longitude;

  const GetHomeClubsParams({this.latitude, this.longitude});

  @override
  List<Object?> get props => [latitude, longitude];
}
