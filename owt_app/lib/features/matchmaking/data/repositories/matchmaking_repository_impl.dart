import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/discover_queue.dart';
import '../../domain/entities/going_tonight_badge.dart';
import '../../domain/entities/like_outcome.dart';
import '../../domain/entities/received_like.dart';
import '../../domain/repositories/matchmaking_repository.dart';
import '../datasources/matchmaking_remote_data_source.dart';
import '../models/discover_profile_model.dart';
import '../models/going_tonight_badge_model.dart';
import '../models/received_like_model.dart';

class MatchmakingRepositoryImpl implements MatchmakingRepository {
  final MatchmakingRemoteDataSource remoteDataSource;

  const MatchmakingRepositoryImpl(this.remoteDataSource);

  @override
  Future<GoingTonightBadge> checkInGoingTonight({
    String? clubId,
    required double latitude,
    required double longitude,
  }) async {
    final bearerToken = await _readBearerToken();
    const fallback = 'Could not verify your location.';
    try {
      final envelope = await remoteDataSource.checkInGoingTonight(bearerToken, {
        'clubId': ?clubId,
        'latitude': latitude,
        'longitude': longitude,
      });
      if (!envelope.success || envelope.data == null) {
        throw ServerFailure(envelope.message ?? fallback);
      }
      return GoingTonightBadgeModel.fromJson(envelope.data!);
    } on DioException catch (e) {
      throw _mapDioException(e, fallbackMessage: fallback);
    }
  }

  @override
  Future<List<GoingTonightBadge>> getActiveBadges() async {
    final bearerToken = await _readBearerToken();
    const fallback = 'Failed to load your Going Tonight status.';
    try {
      final envelope = await remoteDataSource.getGoingTonight(bearerToken);
      if (!envelope.success) {
        throw ServerFailure(envelope.message ?? fallback);
      }
      final sessions = envelope.data?['sessions'];
      if (sessions is! List) return const [];
      return sessions
          .whereType<Map<String, dynamic>>()
          .map(GoingTonightBadgeModel.fromJson)
          .toList();
    } on DioException catch (e) {
      throw _mapDioException(e, fallbackMessage: fallback);
    }
  }

  @override
  Future<void> joinQueue({required String clubId}) async {
    final bearerToken = await _readBearerToken();
    const fallback = 'Failed to join this club.';
    try {
      final envelope = await remoteDataSource.joinQueue(bearerToken, {
        'clubId': clubId,
      });
      if (!envelope.success) {
        throw ServerFailure(envelope.message ?? fallback);
      }
    } on DioException catch (e) {
      throw _mapDioException(e, fallbackMessage: fallback);
    }
  }

  @override
  Future<DiscoverQueue> discover({required String clubId, int? limit}) async {
    final bearerToken = await _readBearerToken();
    const fallback = 'Failed to load people at this club.';
    try {
      final envelope = await remoteDataSource.discover(
        bearerToken,
        clubId,
        limit,
      );
      if (!envelope.success) {
        throw ServerFailure(envelope.message ?? fallback);
      }
      final interval = envelope.meta?['verifiedInterval'];
      return DiscoverQueue(
        profiles: (envelope.data ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(DiscoverProfileModel.fromJson)
            .toList(),
        verifiedInterval: interval is num ? interval.toInt() : null,
        isCheckedInAtClub: envelope.meta?['isCheckedInAtClub'] == true,
      );
    } on DioException catch (e) {
      throw _mapDioException(e, fallbackMessage: fallback);
    }
  }

  @override
  Future<LikeOutcome> like({
    required String receiverId,
    required String clubId,
  }) async {
    final bearerToken = await _readBearerToken();
    const fallback = 'Failed to send your like.';
    try {
      final envelope = await remoteDataSource.like(bearerToken, {
        'receiverId': receiverId,
        'clubId': clubId,
      });
      if (!envelope.success) {
        throw ServerFailure(envelope.message ?? fallback);
      }
      final data = envelope.data;
      // Already matched: the server skips the like and drops a note into
      // the existing chat instead. Body: `{ alreadyMatched, match, message }`.
      if (data?['alreadyMatched'] == true) return LikeOutcome.alreadyMatched;
      return data?['matched'] == true ? LikeOutcome.matched : LikeOutcome.sent;
    } on DioException catch (e) {
      throw _mapDioException(e, fallbackMessage: fallback);
    }
  }

  @override
  Future<void> pass({
    required String receiverId,
    required String clubId,
  }) async {
    final bearerToken = await _readBearerToken();
    const fallback = 'Failed to skip this profile.';
    try {
      final envelope = await remoteDataSource.pass(bearerToken, {
        'receiverId': receiverId,
        'clubId': clubId,
      });
      if (!envelope.success) {
        throw ServerFailure(envelope.message ?? fallback);
      }
    } on DioException catch (e) {
      throw _mapDioException(e, fallbackMessage: fallback);
    }
  }

  @override
  Future<ReceivedLikesPage> getReceivedLikes({
    int page = 1,
    int limit = 20,
  }) async {
    final bearerToken = await _readBearerToken();
    const fallback = 'Failed to load your likes.';
    try {
      final envelope = await remoteDataSource.getReceivedLikes(
        bearerToken,
        page,
        limit,
      );
      if (!envelope.success) {
        throw ServerFailure(envelope.message ?? fallback);
      }
      final meta = envelope.meta;
      int metaInt(String key, int fallback) {
        final value = meta?[key];
        return value is num ? value.toInt() : fallback;
      }

      final entries = (envelope.data ?? const [])
          .whereType<Map<String, dynamic>>();
      return ReceivedLikesPage(
        likes: [
          for (final entry in entries) ...ReceivedLikeModel.fromJson(entry),
        ],
        total: metaInt('total', entries.length),
        page: metaInt('page', page),
        totalPages: metaInt('totalPages', page),
      );
    } on DioException catch (e) {
      throw _mapDioException(e, fallbackMessage: fallback);
    }
  }

  @override
  Future<AcceptLikeResult> acceptLike(String likeId) async {
    final bearerToken = await _readBearerToken();
    const fallback = 'Failed to accept this like.';
    try {
      final envelope = await remoteDataSource.acceptLike(bearerToken, likeId);
      if (!envelope.success) {
        throw ServerFailure(envelope.message ?? fallback);
      }
      final match = envelope.data?['match'];
      return AcceptLikeResult(
        matched: envelope.data?['matched'] == true,
        matchId: match is Map<String, dynamic> ? match['id']?.toString() : null,
      );
    } on DioException catch (e) {
      throw _mapDioException(e, fallbackMessage: fallback);
    }
  }

  @override
  Future<void> declineLike(String likeId) async {
    final bearerToken = await _readBearerToken();
    const fallback = 'Failed to decline this like.';
    try {
      final envelope = await remoteDataSource.declineLike(bearerToken, likeId);
      if (!envelope.success) {
        throw ServerFailure(envelope.message ?? fallback);
      }
    } on DioException catch (e) {
      throw _mapDioException(e, fallbackMessage: fallback);
    }
  }

  @override
  Future<void> blockUser(String userId) async {
    final bearerToken = await _readBearerToken();
    const fallback = 'Failed to block this user.';
    try {
      final envelope = await remoteDataSource.blockUser(bearerToken, userId);
      if (!envelope.success) {
        throw ServerFailure(envelope.message ?? fallback);
      }
    } on DioException catch (e) {
      throw _mapDioException(e, fallbackMessage: fallback);
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
