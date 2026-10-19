import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/interest_category.dart';
import '../../domain/repositories/interests_repository.dart';
import '../datasources/interests_remote_data_source.dart';
import '../models/interest_category_model.dart';
import '../models/update_interests_request_model.dart';

class InterestsRepositoryImpl implements InterestsRepository {
  final InterestsRemoteDataSource remoteDataSource;

  const InterestsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<InterestCategory>> getInterests() async {
    final bearerToken = await _readBearerToken();

    try {
      final envelope = await remoteDataSource.getInterests(bearerToken);
      if (!envelope.success) {
        throw ServerFailure(envelope.message ?? 'Failed to load interests.');
      }

      final categories = envelope.data ?? const [];
      return categories
          .map(
            (json) =>
                InterestCategoryModel.fromJson(json as Map<String, dynamic>)
                    .toEntity(),
          )
          .toList();
    } on DioException catch (e) {
      throw _mapDioException(e, fallbackMessage: 'Failed to load interests.');
    }
  }

  @override
  Future<void> updateSelectedInterests(List<String> interestIds) async {
    final bearerToken = await _readBearerToken();

    try {
      final envelope = await remoteDataSource.updateInterests(
        bearerToken,
        UpdateInterestsRequestModel(interestIds: interestIds),
      );
      if (!envelope.success) {
        throw ServerFailure(envelope.message ?? 'Failed to save interests.');
      }
    } on DioException catch (e) {
      throw _mapDioException(e, fallbackMessage: 'Failed to save interests.');
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
