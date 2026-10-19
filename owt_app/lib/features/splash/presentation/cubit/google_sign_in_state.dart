import 'package:equatable/equatable.dart';

import '../../../auth/domain/entities/auth_session.dart';

enum GoogleSignInStatus {
  idle,
  loading,

  /// Already-registered user — [GoogleSignInCubitState.session] is set.
  loggedIn,

  /// New account — [GoogleSignInCubitState.signupToken] is set; continue
  /// into onboarding to complete registration.
  needsRegistration,

  failure,
}

class GoogleSignInCubitState extends Equatable {
  final GoogleSignInStatus status;
  final String? errorMessage;
  final AuthSession? session;
  final String? signupToken;

  const GoogleSignInCubitState({
    this.status = GoogleSignInStatus.idle,
    this.errorMessage,
    this.session,
    this.signupToken,
  });

  GoogleSignInCubitState copyWith({
    GoogleSignInStatus? status,
    String? errorMessage,
    AuthSession? session,
    String? signupToken,
  }) {
    return GoogleSignInCubitState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      session: session ?? this.session,
      signupToken: signupToken ?? this.signupToken,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, session, signupToken];
}
