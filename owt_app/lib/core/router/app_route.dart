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
  search('/search'),
  profile('/profile'),
  match('/match'),
  settings('/settings'),
  notifications('/notifications');

  const AppRoute(this.path);

  final String path;
}
