import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../storage/token_storage.dart';
import 'debug_log/debug_log_file.dart';
import 'env.dart';

/// Builds the app's single [Dio] instance, pointed at [Env.apiUrl]. Request
/// logging is only attached in debug builds.
///
/// Also installs a queued error interceptor so any 401 from any endpoint is
/// handled the same way: exchange the stored refresh token for a new
/// session via `POST /auth/refresh` and transparently retry the original
/// request, or — if the refresh itself fails (refresh token missing,
/// invalid or expired) — call [onSessionExpired] and let the original error
/// through. [QueuedInterceptorsWrapper] serializes `onError`, so if several
/// requests 401 at once only the first triggers a refresh; the rest wait
/// their turn and retry with the token it produced.
///
/// The refresh call and the retry go through a separate plain [Dio]
/// (same base options, no 401 interceptor): sending them through the main
/// instance would queue any error they hit behind the very `onError` call
/// that's awaiting them — a deadlock that left the original 401 unhandled.
abstract final class DioClient {
  static const _refreshPath = '/auth/refresh';

  /// Request `extra` flag: pass a 401 straight through instead of
  /// refreshing the session (used by `POST /auth/logout`).
  static const skipAuthRefresh = 'skipAuthRefresh';

  static Dio create({required Future<void> Function() onSessionExpired}) {
    final options = BaseOptions(
      baseUrl: Env.apiUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      contentType: Headers.jsonContentType,
    );
    final dio = Dio(options);
    final authDio = Dio(options);

    if (kDebugMode) {
      for (final client in [dio, authDio]) {
        client.interceptors.add(
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseBody: true,
            error: true,
            compact: true,
            // Also copied to a file — see DebugLogFile for why.
            logPrint: (line) {
              debugPrint(line.toString());
              DebugLogFile.write(line);
            },
          ),
        );
      }
    }

    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onError: (error, handler) async {
          if (error.response?.statusCode != 401 ||
              error.requestOptions.extra[skipAuthRefresh] == true) {
            return handler.next(error);
          }

          final String accessToken;
          try {
            accessToken = await _freshAccessToken(
              authDio,
              error.requestOptions,
            );
          } catch (_) {
            await onSessionExpired();
            return handler.next(error);
          }

          final retryOptions = error.requestOptions
            ..headers['Authorization'] = 'Bearer $accessToken';
          try {
            return handler.resolve(await authDio.fetch<dynamic>(retryOptions));
          } on DioException catch (retryError) {
            return handler.next(retryError);
          }
        },
      ),
    );

    return dio;
  }

  /// The access token to retry [failed] with. If another request already
  /// refreshed the session while this one waited in the queue, that newer
  /// stored token is reused; otherwise the session is refreshed now.
  static Future<String> _freshAccessToken(
    Dio authDio,
    RequestOptions failed,
  ) async {
    final stored = await TokenStorage.readAccessToken();
    final sent = failed.headers['Authorization'];
    if (stored != null && sent != 'Bearer $stored') return stored;
    return _refreshAccessToken(authDio);
  }

  /// Calls `POST /auth/refresh` with the stored refresh token and persists
  /// the rotated pair it returns. Throws if there's no refresh token to
  /// send, or the server rejects it (401 — "Invalid/expired refresh token",
  /// or similar).
  static Future<String> _refreshAccessToken(Dio authDio) async {
    final refreshToken = await TokenStorage.readRefreshToken();
    if (refreshToken == null) {
      throw StateError('No refresh token stored.');
    }

    final response = await authDio.post<Map<String, dynamic>>(
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
