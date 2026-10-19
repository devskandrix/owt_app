import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Typed access to the `.env` file (see `.env.example`). Nothing else in
/// the app should read `dotenv` directly — this is the single point that
/// knows the variable names.
abstract final class Env {
  /// Base URL for the versioned REST API, e.g. `http://host:4000/api/v1`.
  static String get apiUrl => dotenv.get('API_URL');

  /// Root server URL without the API path, e.g. `http://host:4000`.
  static String get baseUrl => dotenv.get('BASE_URL');
}
