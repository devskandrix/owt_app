import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../storage/token_storage.dart';
import 'env.dart';

/// Builds the app's single [Dio] instance, pointed at [Env.apiUrl]. Request
/// logging is only attached in debug builds.
///
/// Also installs a queued error interceptor so any 401 from any endpoint is
/// handled the same way: exchange the stored refresh token for a new
/// session via `POST /auth/refresh` and transparently retry the original
/// request, or — if that refresh call itself comes back 401 (refresh token
/// invalid/expired) — call [onSessionExpired] and let the original error
/// through. [QueuedInterceptorsWrapper] serializes `onError`, so if several
/// requests 401 at once only the first triggers a refresh; the rest wait
/// their turn and retry with the token it produced.
abstract final class DioClient {
  static const _refreshPath = '/auth/refresh';

  static Dio create({required Future<void> Function() onSessionExpired}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.apiUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        contentType: Headers.jsonContentType,
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          error: true,
          compact: true,
        ),
      );
    }

    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onError: (error, handler) async {
          final isRefreshCall = error.requestOptions.path == _refreshPath;
          if (error.response?.statusCode != 401 || isRefreshCall) {
            return handler.next(error);
          }

          try {
            final accessToken = await _refreshAccessToken(dio);
            final retryOptions = error.requestOptions
              ..headers['Authorization'] = 'Bearer $accessToken';
            final response = await dio.fetch<dynamic>(retryOptions);
            return handler.resolve(response);
          } catch (_) {
            await onSessionExpired();
            return handler.next(error);
          }
        },
      ),
    );

    return dio;
  }

  /// Calls `POST /auth/refresh` with the stored refresh token and persists
  /// the rotated pair it returns. Throws if there's no refresh token to
  /// send, or the server rejects it (401 — "Invalid/expired refresh token",
  /// or similar).
  static Future<String> _refreshAccessToken(Dio dio) async {
    final refreshToken = await TokenStorage.readRefreshToken();
    if (refreshToken == null) {
      throw StateError('No refresh token stored.');
    }

    final response = await dio.post<Map<String, dynamic>>(
      _refreshPath,
      data: {'refreshToken': refreshToken},
    );
    final data = response.data?['data'] as Map<String, dynamic>?;
    final accessToken = data?['accessToken'] as String?;
    final newRefreshToken = data?['refreshToken'] as String?;
    if (accessToken == null || newRefreshToken == null) {
      throw StateError('Malformed refresh response.');
    }

    await TokenStorage.saveSession(
      accessToken: accessToken,
      refreshToken: newRefreshToken,
    );
    return accessToken;
  }
}
