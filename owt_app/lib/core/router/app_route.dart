/// Centralized route paths and names for [GoRouter].
///
/// Screens navigate via these constants (`context.goNamed(AppRoute.x.name)`)
/// instead of hardcoding path strings or constructing pages directly.
enum AppRoute {
  splash('/'),
  phoneNumber('/phone-number'),
  verification('/verification'),
  createAccount('/create-account'),
  interests('/interests'),
  addPhotos('/add-photos'),
  dashboard('/dashboard'),
  likes('/likes'),
  userDetail('/user-detail'),
  search('/search'),
  profile('/profile'),
  friends('/friends'),
  friendProfile('/friends/profile'),
  match('/match'),
  settings('/settings'),
  about('/settings/about'),
  webPage('/settings/web'),
  notifications('/notifications'),
  messages('/messages'),
  chat('/chat');

  const AppRoute(this.path);

  final String path;
}
