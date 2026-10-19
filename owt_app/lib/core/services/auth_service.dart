import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// The Firebase sign-in result plus the raw Google ID token, which Firebase
/// itself doesn't expose after the fact — our backend's
/// `/auth/social/google` call needs the original token, not a Firebase one.
class GoogleSignInResult {
  final UserCredential firebaseCredential;
  final String idToken;

  const GoogleSignInResult({
    required this.firebaseCredential,
    required this.idToken,
  });
}

/// Wraps Google Sign-In + Firebase Auth. A plain singleton, matching
/// [ThemeController]'s pattern — this app has no other cross-screen state
/// that would justify pulling in the bloc/get_it stack for it.
abstract final class AuthService {
  /// The `client_type: 3` ("Web") OAuth client from
  /// android/app/google-services.json (and mirrored in
  /// ios/Runner/GoogleService-Info.plist). Our backend verifies Google ID
  /// tokens against this audience, so it must be passed as
  /// [GoogleSignIn.initialize]'s `serverClientId` on every platform —
  /// without it, iOS issues tokens scoped to the iOS-native client instead,
  /// which the backend then rejects as "unverifiable".
  static const _webServerClientId =
      '623438415809-3pj9djk8eppknhfosnqde4oiv1j423ap.apps.googleusercontent.com';

  static bool _googleSignInInitialized = false;

  static Future<void> _ensureGoogleSignInInitialized() async {
    if (_googleSignInInitialized) return;
    await GoogleSignIn.instance.initialize(
      // Required on iOS/macOS; unsupported (and ignored) on Android, which
      // instead reads its own native client ID from google-services.json.
      clientId: defaultTargetPlatform == TargetPlatform.iOS
          ? Firebase.app().options.iosClientId
          : null,
      // Required on every platform so the backend gets a consistently
      // audienced token (see _webServerClientId doc above).
      serverClientId: _webServerClientId,
    );
    _googleSignInInitialized = true;
  }

  /// Signs in with Google (via Firebase) and returns both the Firebase
  /// credential and the raw Google ID token, or null if the user cancelled
  /// the sign-in flow. Any other failure (network error, misconfiguration,
  /// ...) is rethrown as a [GoogleSignInException] or [FirebaseAuthException].
  static Future<GoogleSignInResult?> signInWithGoogle() async {
    await _ensureGoogleSignInInitialized();

    final GoogleSignInAccount account;
    try {
      account = await GoogleSignIn.instance.authenticate();
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    }

    final idToken = account.authentication.idToken;
    if (idToken == null) {
      throw const GoogleSignInException(
        code: GoogleSignInExceptionCode.unknownError,
        description: 'Google did not return an ID token.',
      );
    }

    final credential = GoogleAuthProvider.credential(idToken: idToken);
    final firebaseCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );
    return GoogleSignInResult(
      firebaseCredential: firebaseCredential,
      idToken: idToken,
    );
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn.instance.signOut();
  }
}
