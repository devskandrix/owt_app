import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Typed access to the `.env` file (see `.env.example`). Nothing else in
/// the app should read `dotenv` directly — this is the single point that
/// knows the variable names.
abstract final class Env {
  /// Base URL for the versioned REST API, e.g. `http://host:4000/api/v1`.
  static String get apiUrl => dotenv.get('API_URL');

  /// Root server URL without the API path, e.g. `http://host:4000`.
  static String get baseUrl => dotenv.get('BASE_URL');

  /// Chat socket server, e.g. `http://localhost:4000`. Optional: defaults
  /// to [baseUrl]. A `localhost` host is swapped for [baseUrl]'s host
  /// (see `ChatSocketService`), since on a phone it means the phone.
  static String get socketUrl {
    final value = dotenv.maybeGet('SOCKET_URL')?.trim() ?? '';
    return value.isEmpty ? baseUrl : value;
  }

  /// ZEGOCLOUD project AppID (calls); 0 when not set.
  static int get zegoAppId =>
      int.tryParse(dotenv.maybeGet('ZEGO_APP_ID') ?? '') ?? 0;

  /// ZEGOCLOUD AppSign (app-side key); empty when not set. Development
  /// only: leave it out of live builds, which sign in with a token.
  static String get zegoAppSign => dotenv.maybeGet('ZEGO_APP_SIGN') ?? '';

  /// Whether ZEGOCLOUD signs in with a token from `GET /zego/token` (live
  /// mode) instead of the AppSign. True when `ZEGO_USE_TOKEN=true`, or when
  /// no AppSign is set.
  static bool get zegoUseToken =>
      dotenv.maybeGet('ZEGO_USE_TOKEN')?.toLowerCase() == 'true' ||
      zegoAppSign.isEmpty;

  /// Whether voice / video calls can be used in this build.
  static bool get hasZego => zegoAppId != 0;
}
