import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../profile/data/models/my_profile_model.dart';
import '../../../profile/domain/entities/my_profile.dart';
import '../../domain/entities/friend.dart';
import '../../domain/repositories/friends_repository.dart';
import '../models/friend_model.dart';

/// Calls [Dio] directly rather than through retrofit: `GET /matches`'s
/// `data` isn't documented, so it may be a list or an object wrapping one
/// (`{ matches: [...] }`), and both are handled here.
class FriendsRepositoryImpl implements FriendsRepository {
  final Dio dio;

  const FriendsRepositoryImpl(this.dio);

  @override
  Future<MyProfile> getFriendProfile(String matchId) async {
    const fallback = 'Failed to load this profile.';
    final data = await _get('/matches/$matchId', fallback);
    final user = data is Map<String, dynamic> ? data['user'] : null;
    if (user is! Map<String, dynamic>) {
      throw const ServerFailure(fallback);
    }
    return MyProfileModel.fromJson(user);
  }

  @override
  Future<List<Friend>> getFriends() async {
    final data = await _get('/matches', 'Failed to load your friends.');
    final items = switch (data) {
      final List<dynamic> list => list,
      {'matches': final List<dynamic> list} => list,
      {'items': final List<dynamic> list} => list,
      _ => const <dynamic>[],
    };
    return [
      for (final item in items.whereType<Map<String, dynamic>>())
        ?FriendModel.fromJson(item),
    ];
  }

  /// GETs [path] and returns the envelope's `data` once `success` is true.
  Future<dynamic> _get(String path, String fallback) async {
    final accessToken = await TokenStorage.readAccessToken();
    if (accessToken == null) {
      throw const UnexpectedFailure('Missing session. Please sign in again.');
    }
    try {
      final response = await dio.get<dynamic>(
        path,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );
      final body = response.data;
      if (body is! Map<String, dynamic> || body['success'] != true) {
        final message = body is Map<String, dynamic> ? body['message'] : null;
        throw ServerFailure(message is String ? message : fallback);
      }
      return body['data'];
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
