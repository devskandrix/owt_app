import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/my_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/my_profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  const ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<MyProfile> getMyProfile() async {
    final accessToken = await TokenStorage.readAccessToken();
    if (accessToken == null) {
      throw const UnexpectedFailure('Missing session. Please sign in again.');
    }
    const fallback = 'Failed to load your profile.';
    try {
      final envelope = await remoteDataSource.getMe('Bearer $accessToken');
      final data = envelope.data;
      if (!envelope.success || data == null) {
        throw ServerFailure(envelope.message ?? fallback);
      }
      return MyProfileModel.fromJson(data);
    } on DioException catch (e) {
      throw _mapDioException(e, fallbackMessage: fallback);
    }
  }

  @override
  Future<void> deactivateAccount() async {
    final accessToken = await TokenStorage.readAccessToken();
    if (accessToken == null) {
      throw const UnexpectedFailure('Missing session. Please sign in again.');
    }
    const fallback = 'Failed to deactivate your account.';
    try {
      final envelope = await remoteDataSource.deactivateMe(
        'Bearer $accessToken',
      );
      if (!envelope.success) {
        throw ServerFailure(envelope.message ?? fallback);
      }
    } on DioException catch (e) {
      throw _mapDioException(e, fallbackMessage: fallback);
    }
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
