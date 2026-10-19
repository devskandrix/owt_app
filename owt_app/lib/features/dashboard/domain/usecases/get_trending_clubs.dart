import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/club.dart';
import '../repositories/clubs_repository.dart';

class GetTrendingClubs implements UseCase<List<Club>, GetTrendingClubsParams> {
  final ClubsRepository repository;

  const GetTrendingClubs(this.repository);

  @override
  Future<List<Club>> call(GetTrendingClubsParams params) {
    return repository.getTrending(limit: params.limit);
  }
}

class GetTrendingClubsParams extends Equatable {
  final int? limit;

  const GetTrendingClubsParams({this.limit});

  @override
  List<Object?> get props => [limit];
}
