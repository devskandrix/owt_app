import 'package:flutter/material.dart';

/// App-wide theme mode, toggled by the Settings screen's "Dark Mode"
/// switch. A plain [ValueNotifier] rather than a Bloc/Cubit — this is the
/// only piece of cross-screen state in the app, so a lightweight listenable
/// is simpler than pulling in the state-management stack for one flag.
abstract final class ThemeController {
  static final ValueNotifier<ThemeMode> mode = ValueNotifier(ThemeMode.dark);
}
