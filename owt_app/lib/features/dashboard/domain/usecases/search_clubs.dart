import 'package:equatable/equatable.dart';

import '../../../../core/usecase/usecase.dart';
import '../entities/club_search_page.dart';
import '../repositories/clubs_repository.dart';

class SearchClubs implements UseCase<ClubSearchPage, SearchClubsParams> {
  final ClubsRepository repository;

  const SearchClubs(this.repository);

  @override
  Future<ClubSearchPage> call(SearchClubsParams params) {
    return repository.search(
      query: params.query,
      city: params.city,
      country: params.country,
      limit: params.limit,
      page: params.page,
    );
  }
}

class SearchClubsParams extends Equatable {
  /// Club name, partial and case-insensitive. Null or empty lists every club.
  final String? query;
  final String? city;
  final String? country;

  /// 1–50; the server defaults to 20.
  final int? limit;

  /// 1-based; the server defaults to 1.
  final int? page;

  const SearchClubsParams({
    this.query,
    this.city,
    this.country,
    this.limit,
    this.page,
  });

  @override
  List<Object?> get props => [query, city, country, limit, page];
}
