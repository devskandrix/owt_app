import '../entities/auth_session.dart';
import '../entities/gender.dart';
import '../entities/social_auth_provider.dart';
import '../entities/social_auth_result.dart';

abstract class AuthRepository {
  /// Exchanges a social provider's ID token for our backend's own session,
  /// via `POST /auth/social/:provider`.
  Future<SocialAuthResult> signInWithSocialProvider({required SocialAuthProvider provider, required String idToken});

  /// Sends an OTP to [phoneNumber] for the in-progress signup, via
  /// `POST /auth/signup/phone/send-otp` (authorized by the signup token
  /// saved from [signInWithSocialProvider]).
  Future<void> sendSignupOtp({required String phoneNumber});

  /// Verifies the [otp] sent to [phoneNumber], via
  /// `POST /auth/signup/phone/verify-otp`. On success, the signup token is
  /// replaced with the new one the server returns.
  Future<void> verifySignupOtp({
    required String phoneNumber,
    required String otp,
  });

  /// Completes signup via `POST /auth/register`, authorized by the signup
  /// token saved from [verifySignupOtp]. Returns the new account's session.
  Future<AuthSession> register({
    required String? fullName,
    required DateTime dateOfBirth,
    required Gender gender,
  });
}
