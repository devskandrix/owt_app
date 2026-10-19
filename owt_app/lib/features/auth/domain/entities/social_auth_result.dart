import 'package:equatable/equatable.dart';

import 'auth_session.dart';

/// The outcome of `POST /auth/social/:provider`: the backend either
/// recognizes the account and logs it straight in, or it's a new account
/// that still needs to complete registration.
sealed class SocialAuthResult extends Equatable {
  const SocialAuthResult();
}

/// An already-registered user — [session] is ready to use immediately.
class SocialAuthLoggedIn extends SocialAuthResult {
  final AuthSession session;

  const SocialAuthLoggedIn(this.session);

  @override
  List<Object?> get props => [session];
}

/// A new account. [signupToken] identifies the verified social identity to
/// the backend for the remaining onboarding steps (phone number, profile,
/// ...) — carry it through until registration is submitted.
class SocialAuthNeedsRegistration extends SocialAuthResult {
  final String signupToken;

  const SocialAuthNeedsRegistration(this.signupToken);

  @override
  List<Object?> get props => [signupToken];
}
