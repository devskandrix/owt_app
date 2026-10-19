/// The identity providers accepted by `POST /auth/social/:provider`.
enum SocialAuthProvider {
  google('google'),
  apple('apple');

  const SocialAuthProvider(this.pathValue);

  /// The exact string this provider maps to in the API path, e.g.
  /// `/auth/social/google`.
  final String pathValue;
}
