import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/network/models/api_envelope_model.dart';
import '../models/register_request_model.dart';
import '../models/send_signup_otp_request_model.dart';
import '../models/social_auth_request_model.dart';
import '../models/verify_signup_otp_request_model.dart';

part 'auth_remote_data_source.g.dart';

@RestApi()
abstract class AuthRemoteDataSource {
  factory AuthRemoteDataSource(Dio dio) = _AuthRemoteDataSource;

  /// `data`'s shape depends on whether the account already exists (see
  /// [SocialAuthResult]), so it's discriminated in `AuthRepositoryImpl`
  /// rather than modeled as one fixed response type here.
  @POST('/auth/social/{provider}')
  Future<ApiEnvelopeModel> socialSignIn(
    @Path('provider') String provider,
    @Body() SocialAuthRequestModel body,
  );

  /// Sends an OTP to [body]'s phone number for a new account still mid
  /// signup, authorized by the `signupToken` from [socialSignIn].
  @POST('/auth/signup/phone/send-otp')
  Future<ApiEnvelopeModel> sendSignupOtp(
    @Header('Authorization') String bearerToken,
    @Body() SendSignupOtpRequestModel body,
  );

  /// Verifies the OTP sent by [sendSignupOtp], authorized by the same
  /// signup token. On success the response carries a new signup token that
  /// replaces it for the remaining onboarding steps.
  @POST('/auth/signup/phone/verify-otp')
  Future<ApiEnvelopeModel> verifySignupOtp(
    @Header('Authorization') String bearerToken,
    @Body() VerifySignupOtpRequestModel body,
  );

  /// Completes signup, authorized by the signup token from
  /// [verifySignupOtp]. The verified phone number is taken from that token
  /// server-side, never from the request body.
  @POST('/auth/register')
  Future<ApiEnvelopeModel> register(
    @Header('Authorization') String bearerToken,
    @Body() RegisterRequestModel body,
  );

  /// Revokes [body]'s `refreshToken` server-side. Mobile has no refresh
  /// cookie, so the token goes in the body. A 401 here must not trigger a
  /// session refresh (see `DioClient.skipAuthRefresh`).
  @POST('/auth/logout')
  @Extra({'skipAuthRefresh': true})
  Future<ApiEnvelopeModel> logout(
    @Header('Authorization') String bearerToken,
    @Body() Map<String, dynamic> body,
  );
}
