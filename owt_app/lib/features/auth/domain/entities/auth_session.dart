import 'package:equatable/equatable.dart';

import 'auth_user.dart';

/// An already-registered user's session: our backend's own access/refresh
/// tokens plus the profile it resolved.
class AuthSession extends Equatable {
  final String accessToken;
  final String refreshToken;
  final AuthUser user;

  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  @override
  List<Object?> get props => [accessToken, refreshToken, user];
}
