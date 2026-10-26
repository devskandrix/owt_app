import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/zego_token.dart';
import '../../domain/repositories/zego_token_repository.dart';
import '../datasources/zego_token_remote_data_source.dart';

class ZegoTokenRepositoryImpl implements ZegoTokenRepository {
  final ZegoTokenRemoteDataSource remoteDataSource;

  const ZegoTokenRepositoryImpl(this.remoteDataSource);

  @override
  Future<ZegoToken> getToken() async {
    final accessToken = await TokenStorage.readAccessToken();
    if (accessToken == null) {
      throw const UnexpectedFailure('Missing session. Please sign in again.');
    }
    const fallback = 'Failed to get a chat token.';
    try {
      final envelope = await remoteDataSource.getToken('Bearer $accessToken');
      final data = envelope.data;
      final token = data?['token'];
      final expiresAt = data?['expiresAt'];
      if (!envelope.success || token is! String || token.isEmpty) {
        throw ServerFailure(envelope.message ?? fallback);
      }
      return ZegoToken(
        token: token,
        // Without a usable expiry, assume a short life so it's renewed soon.
        expiresAt:
            (expiresAt is String ? DateTime.tryParse(expiresAt) : null) ??
            DateTime.now().add(const Duration(hours: 1)),
      );
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final body = e.response?.data;
      final message = body is Map<String, dynamic> ? body['message'] : null;
      throw ServerFailure(
        message is String ? message : '$fallback (${status ?? e.type.name}).',
        statusCode: status,
      );
    }
  }
}
