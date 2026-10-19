import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/models/api_envelope_model.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/photo.dart';
import '../../domain/repositories/photos_repository.dart';
import '../datasources/photos_remote_data_source.dart';
import '../models/photo_model.dart';

class PhotosRepositoryImpl implements PhotosRepository {
  final PhotosRemoteDataSource remoteDataSource;
  final Dio dio;

  const PhotosRepositoryImpl(this.remoteDataSource, this.dio);

  @override
  Future<List<Photo>> getMyPhotos() async {
    final bearerToken = await _readBearerToken();

    try {
      final envelope = await remoteDataSource.getMe(bearerToken);
      if (!envelope.success) {
        throw ServerFailure(envelope.message ?? 'Failed to load photos.');
      }

      final photosJson = envelope.data?['photos'] as List<dynamic>? ?? const [];
      return photosJson
          .map(
            (json) =>
                PhotoModel.fromJson(json as Map<String, dynamic>).toEntity(),
          )
          .toList();
    } on DioException catch (e) {
      throw _mapDioException(e, fallbackMessage: 'Failed to load photos.');
    }
  }

  @override
  Future<Photo> uploadPhoto({
    required Uint8List bytes,
    required String fileName,
  }) async {
    final bearerToken = await _readBearerToken();

    try {
      final formData = FormData.fromMap({
        'photo': MultipartFile.fromBytes(
          bytes,
          filename: fileName,
          contentType: _mediaTypeFor(fileName),
        ),
      });
      final response = await dio.post<Map<String, dynamic>>(
        '/users/me/photos',
        data: formData,
        options: Options(headers: {'Authorization': bearerToken}),
      );
      final envelope = ApiEnvelopeModel.fromJson(response.data!);
      if (!envelope.success) {
        throw ServerFailure(envelope.message ?? 'Failed to upload photo.');
      }

      final data = envelope.data;
      if (data == null) {
        throw const UnexpectedFailure('Server response is missing photo data.');
      }
      return PhotoModel.fromJson(data).toEntity();
    } on DioException catch (e) {
      throw _mapDioException(e, fallbackMessage: 'Failed to upload photo.');
    }
  }

  @override
  Future<void> deletePhoto(String photoId) async {
    final bearerToken = await _readBearerToken();

    try {
      final envelope = await remoteDataSource.deletePhoto(bearerToken, photoId);
      if (!envelope.success) {
        throw ServerFailure(envelope.message ?? 'Failed to delete photo.');
      }
    } on DioException catch (e) {
      throw _mapDioException(e, fallbackMessage: 'Failed to delete photo.');
    }
  }

  MediaType _mediaTypeFor(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'png':
        return MediaType('image', 'png');
      case 'webp':
        return MediaType('image', 'webp');
      case 'jpg':
      case 'jpeg':
      default:
        return MediaType('image', 'jpeg');
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
