import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/club.dart';
import '../../domain/entities/home_clubs.dart';
import '../../domain/repositories/clubs_repository.dart';
import '../datasources/clubs_remote_data_source.dart';
import '../models/club_model.dart';
import '../models/home_clubs_model.dart';

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
