import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/club.dart';
import '../../domain/entities/club_search_page.dart';
import '../../domain/entities/home_clubs.dart';
import '../../domain/entities/search_history_item.dart';
import '../../domain/repositories/clubs_repository.dart';
import '../datasources/clubs_remote_data_source.dart';
import '../models/club_model.dart';
import '../models/home_clubs_model.dart';
import '../models/search_history_item_model.dart';

class ClubsRepositoryImpl implements ClubsRepository {
  final ClubsRemoteDataSource remoteDataSource;

  const ClubsRepositoryImpl(this.remoteDataSource);

  @override
  Future<HomeClubs> getHome({double? latitude, double? longitude}) async {
    final bearerToken = await _readBearerToken();

    try {
      final envelope = await remoteDataSource.getHome(
        bearerToken,
        latitude,
        longitude,
      );
      if (!envelope.success) {
        throw ServerFailure(envelope.message ?? 'Failed to load clubs.');
      }

      return HomeClubsModel.fromJson(envelope.data ?? const {}).toEntity();
    } on DioException catch (e) {
      throw _mapDioException(e, fallbackMessage: 'Failed to load clubs.');
    }
  }

  @override
  Future<ClubSearchPage> search({
    String? query,
    String? city,
    String? country,
    int? limit,
    int? page,
  }) async {
    final bearerToken = await _readBearerToken();

    try {
      final envelope = await remoteDataSource.search(
        bearerToken,
        query,
        city,
        country,
        limit,
        page,
      );
      if (!envelope.success) {
        throw ServerFailure(envelope.message ?? 'Failed to search clubs.');
      }

      final clubs = [
        for (final json in envelope.data ?? const [])
          if (json is Map<String, dynamic>) ClubModel.fromJson(json).toEntity(),
      ];
      final meta = envelope.meta ?? const <String, dynamic>{};
      final resolvedPage = _int(meta['page']) ?? page ?? 1;
      return ClubSearchPage(
        clubs: clubs,
        total: _int(meta['total']) ?? clubs.length,
        page: resolvedPage,
        limit: _int(meta['limit']) ?? limit ?? clubs.length,
        totalPages: _int(meta['totalPages']) ?? resolvedPage,
      );
    } on DioException catch (e) {
      throw _mapDioException(e, fallbackMessage: 'Failed to search clubs.');
    }
  }

  @override
  Future<void> saveSearchHistory({
    required String clubId,
    String? query,
  }) async {
    const fallback = 'Failed to save search.';
    final bearerToken = await _readBearerToken();
    try {
      final envelope = await remoteDataSource.saveSearchHistory(bearerToken, {
        'clubId': clubId,
        if (query != null && query.isNotEmpty) 'query': query,
      });
      if (!envelope.success) {
        throw ServerFailure(envelope.message ?? fallback);
      }
    } on DioException catch (e) {
      throw _mapDioException(e, fallbackMessage: fallback);
    }
  }

  @override
  Future<List<SearchHistoryItem>> getSearchHistory({int? limit}) async {
    const fallback = 'Failed to load recent searches.';
    final bearerToken = await _readBearerToken();
    try {
      final envelope = await remoteDataSource.getSearchHistory(
        bearerToken,
        limit,
      );
      if (!envelope.success) {
        throw ServerFailure(envelope.message ?? fallback);
      }
      return [
        for (final json in envelope.data ?? const [])
          // Skip entries whose club was removed server-side.
          if (json is Map<String, dynamic> && json['club'] is Map)
            SearchHistoryItemModel.fromJson(json).toEntity(),
      ];
    } on DioException catch (e) {
      throw _mapDioException(e, fallbackMessage: fallback);
    }
  }

  @override
  Future<void> deleteSearchHistory(String historyId) async {
    const fallback = 'Failed to remove search.';
    final bearerToken = await _readBearerToken();
    try {
      final envelope = await remoteDataSource.deleteSearchHistory(
        bearerToken,
        historyId,
      );
      if (!envelope.success) {
        throw ServerFailure(envelope.message ?? fallback);
      }
    } on DioException catch (e) {
      throw _mapDioException(e, fallbackMessage: fallback);
    }
  }

  @override
  Future<void> clearSearchHistory() async {
    const fallback = 'Failed to clear recent searches.';
    final bearerToken = await _readBearerToken();
    try {
      final envelope = await remoteDataSource.clearSearchHistory(bearerToken);
      if (!envelope.success) {
        throw ServerFailure(envelope.message ?? fallback);
      }
    } on DioException catch (e) {
      throw _mapDioException(e, fallbackMessage: fallback);
    }
  }

  @override
  Future<List<Club>> getTrending({int? limit}) async {
    final bearerToken = await _readBearerToken();

    try {
      final envelope = await remoteDataSource.getTrending(bearerToken, limit);
      if (!envelope.success) {
        throw ServerFailure(
          envelope.message ?? 'Failed to load trending clubs.',
        );
      }

      final clubs = envelope.data ?? const [];
      return clubs
          .map(
            (json) =>
                ClubModel.fromJson(json as Map<String, dynamic>).toEntity(),
          )
          .toList();
    } on DioException catch (e) {
      throw _mapDioException(
        e,
        fallbackMessage: 'Failed to load trending clubs.',
      );
    }
  }

  static int? _int(Object? value) => value is num ? value.toInt() : null;

  Future<String> _readBearerToken() async {
    final accessToken = await TokenStorage.readAccessToken();
    if (accessToken == null) {
      throw const UnexpectedFailure('Missing session. Please sign in again.');
    }
    return 'Bearer $accessToken';
  }

  Failure _mapDioException(DioException e, {required String fallbackMessage}) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return NetworkFailure(
          'Could not reach the server. Check your connection and try again.',
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        final serverMessage = data is Map<String, dynamic>
            ? data['message'] as String?
            : null;
        return ServerFailure(
          serverMessage ?? '$fallbackMessage (${statusCode ?? 'unknown'}).',
          statusCode: statusCode,
        );
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
      // ignore: no_default_cases
      default:
        return UnexpectedFailure(e.message ?? fallbackMessage);
    }
  }
}
