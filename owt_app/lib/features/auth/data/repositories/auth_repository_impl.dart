import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/models/api_envelope_model.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/gender.dart';
import '../../domain/entities/social_auth_provider.dart';
import '../../domain/entities/social_auth_result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_user_model.dart';
import '../models/register_request_model.dart';
import '../models/send_signup_otp_request_model.dart';
import '../models/social_auth_request_model.dart';
import '../models/verify_signup_otp_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<SocialAuthResult> signInWithSocialProvider({
    required SocialAuthProvider provider,
    required String idToken,
  }) async {
    try {
      final envelope = await remoteDataSource.socialSignIn(
        provider.pathValue,
        SocialAuthRequestModel(idToken: idToken),
      );
      return _parseSocialAuthEnvelope(envelope);
    } on DioException catch (e) {
      throw _mapDioException(e, fallbackMessage: 'Sign-in failed.');
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure('Could not process the server response: $e');
    }
  }

  @override
  Future<void> sendSignupOtp({required String phoneNumber}) async {
    final signupToken = await TokenStorage.readSignupToken();
    if (signupToken == null) {
      throw const UnexpectedFailure(
        'Missing signup session. Please sign in again.',
      );
    }

    try {
      final envelope = await remoteDataSource.sendSignupOtp(
        'Bearer $signupToken',
        SendSignupOtpRequestModel(phoneNumber: phoneNumber),
      );
      if (!envelope.success) {
        throw ServerFailure(envelope.message ?? 'Failed to send OTP.');
      }
    } on DioException catch (e) {
      throw _mapDioException(e, fallbackMessage: 'Failed to send OTP.');
    }
  }

  @override
  Future<void> verifySignupOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    final signupToken = await TokenStorage.readSignupToken();
    if (signupToken == null) {
      throw const UnexpectedFailure(
        'Missing signup session. Please sign in again.',
      );
    }

    try {
      final envelope = await remoteDataSource.verifySignupOtp(
        'Bearer $signupToken',
        VerifySignupOtpRequestModel(phoneNumber: phoneNumber, otp: otp),
      );
      if (!envelope.success) {
        throw ServerFailure(envelope.message ?? 'Failed to verify OTP.');
      }

      final newSignupToken = envelope.data?['signupToken'] as String?;
      if (newSignupToken == null) {
        throw const UnexpectedFailure(
          'Server response is missing signupToken.',
        );
      }
      await TokenStorage.saveSignupToken(newSignupToken);
    } on DioException catch (e) {
      throw _mapDioException(e, fallbackMessage: 'Failed to verify OTP.');
    }
  }

  @override
  Future<AuthSession> register({
    required String? fullName,
    required DateTime dateOfBirth,
    required Gender gender,
  }) async {
    final signupToken = await TokenStorage.readSignupToken();
    if (signupToken == null) {
      throw const UnexpectedFailure(
        'Missing signup session. Please sign in again.',
      );
    }
    final email = await TokenStorage.readSignupEmail();

    try {
      final envelope = await remoteDataSource.register(
        'Bearer $signupToken',
        RegisterRequestModel(
          fullName: fullName,
          dateOfBirth: _formatDate(dateOfBirth),
          gender: gender.apiValue,
          email: email,
        ),
      );
      final session = _parseSessionEnvelope(
        envelope,
        fallbackMessage: 'Registration failed.',
      );
      await TokenStorage.saveSession(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
      );
      await TokenStorage.clearSignupToken();
      await TokenStorage.clearSignupEmail();
      return session;
    } on DioException catch (e) {
      throw _mapDioException(e, fallbackMessage: 'Registration failed.');
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure('Could not process the server response: $e');
    }
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  SocialAuthResult _parseSocialAuthEnvelope(ApiEnvelopeModel envelope) {
    if (!envelope.success) {
      throw ServerFailure(envelope.message ?? 'Sign-in failed.');
    }

    final data = envelope.data ?? const {};

    if (data['needsRegistration'] == true) {
      final signupToken = data['signupToken'] as String?;
      if (signupToken == null) {
        throw const UnexpectedFailure(
          'Server response is missing signupToken.',
        );
      }
      return SocialAuthNeedsRegistration(signupToken);
    }

    return SocialAuthLoggedIn(
      _parseSessionEnvelope(envelope, fallbackMessage: 'Sign-in failed.'),
    );
  }

  AuthSession _parseSessionEnvelope(
    ApiEnvelopeModel envelope, {
    required String fallbackMessage,
  }) {
    if (!envelope.success) {
      throw ServerFailure(envelope.message ?? fallbackMessage);
    }

    final data = envelope.data ?? const {};
    final userJson = data['user'] as Map<String, dynamic>?;
    final accessToken = data['accessToken'] as String?;
    final refreshToken = data['refreshToken'] as String?;
    if (userJson == null || accessToken == null || refreshToken == null) {
      throw const UnexpectedFailure(
        'Server response is missing user/accessToken/refreshToken.',
      );
    }

    return AuthSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      user: AuthUserModel.fromJson(userJson).toEntity(),
    );
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
