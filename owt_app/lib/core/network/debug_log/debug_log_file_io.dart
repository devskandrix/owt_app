import 'dart:io';

/// Debug-only copy of the API request logs in the app's temp/cache folder
/// (`api_log.txt` — `code_cache/` on Android), cleared on each launch.
///
/// Some Android builds (e.g. Vivo) mask URLs, coordinates and links in
/// logcat, which is where `flutter run` reads app output from — so the
/// console shows `*****` in their place. This file bypasses logcat; stream
/// it from the phone with `tool/android_api_logs.sh`.
abstract final class DebugLogFile {
  static IOSink? _sink;

  static void write(Object? line) {
    try {
      _sink ??= File('${Directory.systemTemp.path}/api_log.txt')
          .openWrite(mode: FileMode.write);
      _sink!.writeln(line);
    } catch (_) {
      // Logging must never break a request.
    }
  }
}
