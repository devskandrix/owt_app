/// No file to write to on web; logs stay in the console only.
abstract final class DebugLogFile {
  static void write(Object? line) {}
}
