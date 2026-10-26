import 'env.dart';

/// Makes an image URL from the API loadable on the device.
///
/// The server builds upload URLs from its own host (e.g.
/// `http://localhost:4000/uploads/...`), which on a phone points at the
/// phone itself. Those, and relative paths like `/uploads/...`, are moved
/// onto [Env.baseUrl]'s scheme, host and port. Other URLs are unchanged.
String resolveMediaUrl(String url) {
  final uri = Uri.tryParse(url.trim());
  if (uri == null) return url;
  final base = Uri.tryParse(Env.baseUrl);
  if (base == null) return url;
  if (!uri.hasScheme) {
    return base
        .resolve(uri.path.startsWith('/') ? uri.path : '/${uri.path}')
        .replace(query: uri.hasQuery ? uri.query : null)
        .toString();
  }
  const localHosts = {'localhost', '127.0.0.1', '0.0.0.0', '::1'};
  if (!localHosts.contains(uri.host)) return url;
  return uri
      .replace(scheme: base.scheme, host: base.host, port: base.port)
      .toString();
}
