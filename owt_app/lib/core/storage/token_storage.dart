import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists auth tokens in the platform keychain/keystore. Nothing else in
/// the app should hold these long-term — read them fresh from here when
/// building an authenticated request.
abstract final class TokenStorage {
  static const _storage = FlutterSecureStorage();
  static const _accessTokenKey = 'auth_access_token';
  static const _refreshTokenKey = 'auth_refresh_token';
  static const _signupTokenKey = 'auth_signup_token';
  static const _signupEmailKey = 'auth_signup_email';

  /// A logged-in session's tokens (an already-registered user).
  static Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  static Future<String?> readAccessToken() =>
      _storage.read(key: _accessTokenKey);

  static Future<String?> readRefreshToken() =>
      _storage.read(key: _refreshTokenKey);

  /// Whether a logged-in session is already stored, i.e. the user completed
  /// login/signup on a previous launch. The access token itself doubles as
  /// this flag — a separate boolean would just risk drifting out of sync
  /// with it — so this is what decides whether app start shows the splash
  /// (login) screen or skips straight to the dashboard.
  static Future<bool> hasSession() async => await readAccessToken() != null;

  /// A new account's signup token, carried through the remaining onboarding
  /// steps until registration is submitted.
  static Future<void> saveSignupToken(String signupToken) =>
      _storage.write(key: _signupTokenKey, value: signupToken);

  static Future<String?> readSignupToken() =>
      _storage.read(key: _signupTokenKey);

  /// Discards the signup token once registration is complete and it's
  /// replaced by a real session.
  static Future<void> clearSignupToken() =>
      _storage.delete(key: _signupTokenKey);

  /// The email address from the social identity that started signup (e.g.
  /// Google), carried alongside the signup token so it can be sent with
  /// `POST /auth/register`.
  static Future<void> saveSignupEmail(String email) =>
      _storage.write(key: _signupEmailKey, value: email);

  static Future<String?> readSignupEmail() =>
      _storage.read(key: _signupEmailKey);

  static Future<void> clearSignupEmail() =>
      _storage.delete(key: _signupEmailKey);

  static Future<void> clear() => _storage.deleteAll();
}
