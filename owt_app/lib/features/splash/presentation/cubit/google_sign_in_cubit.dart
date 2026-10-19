import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../auth/domain/entities/social_auth_provider.dart';
import '../../../auth/domain/entities/social_auth_result.dart';
import '../../../auth/domain/usecases/social_sign_in.dart';
import 'google_sign_in_state.dart';

class GoogleSignInCubit extends Cubit<GoogleSignInCubitState> {
  GoogleSignInCubit(this._socialSignIn) : super(const GoogleSignInCubitState());

  final SocialSignIn _socialSignIn;

  Future<void> signIn() async {
    emit(state.copyWith(status: GoogleSignInStatus.loading));
    try {
      // 1. Google Sign-In (client-side identity) via Firebase.
      final googleResult = await AuthService.signInWithGoogle();
      if (googleResult == null) {
        // User cancelled the flow.
        emit(state.copyWith(status: GoogleSignInStatus.idle));
        return;
      }

      // 2. Exchange the Google ID token for our own backend session — the
      // backend tells us whether this is an existing account or a new one.
      final result = await _socialSignIn(
        SocialSignInParams(
          provider: SocialAuthProvider.google,
          idToken: googleResult.idToken,
        ),
      );

      switch (result) {
        case SocialAuthLoggedIn(:final session):
          await TokenStorage.saveSession(
            accessToken: session.accessToken,
            refreshToken: session.refreshToken,
          );
          emit(
            state.copyWith(
              status: GoogleSignInStatus.loggedIn,
              session: session,
            ),
          );
        case SocialAuthNeedsRegistration(:final signupToken):
          await TokenStorage.saveSignupToken(signupToken);
          final email = googleResult.firebaseCredential.user?.email;
          if (email != null) {
            await TokenStorage.saveSignupEmail(email);
          }
          emit(
            state.copyWith(
              status: GoogleSignInStatus.needsRegistration,
              signupToken: signupToken,
            ),
          );
      }
    } on GoogleSignInException catch (e) {
      emit(
        state.copyWith(
          status: GoogleSignInStatus.failure,
          errorMessage: e.description ?? AppStrings.googleSignInFailed,
        ),
      );
    } on FirebaseAuthException catch (e) {
      emit(
        state.copyWith(
          status: GoogleSignInStatus.failure,
          errorMessage: e.message ?? AppStrings.googleSignInFailed,
        ),
      );
    } on Failure catch (f) {
      emit(
        state.copyWith(
          status: GoogleSignInStatus.failure,
          errorMessage: f.message,
        ),
      );
    } catch (_) {
      // Anything else (e.g. Firebase not configured for this platform):
      // still surface a failure instead of leaving the button stuck loading.
      emit(
        state.copyWith(
          status: GoogleSignInStatus.failure,
          errorMessage: AppStrings.googleSignInFailed,
        ),
      );
    }
  }
}
