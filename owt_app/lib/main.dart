import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/di/injection_container.dart';
import 'core/router/app_route.dart';
import 'core/router/app_router.dart';
import 'core/storage/token_storage.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  // Only Android and iOS Firebase apps are registered (see
  // firebase_options.dart) — skip on web so the browser-based dev preview
  // used throughout this project keeps working without a web Firebase app.
  if (!kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  await initDependencies(onSessionExpired: _signOut);
  runApp(const MyApp());
}

/// Wired into the shared [Dio] client (see [DioClient]) as its
/// `onSessionExpired` callback: fires when a 401 couldn't be resolved by
/// refreshing the session, so the stored tokens are stale/invalid — clear
/// them and send the user back to sign in.
Future<void> _signOut() async {
  await TokenStorage.clear();
  AppRouter.router.goNamed(AppRoute.splash.name);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.mode,
      builder: (context, themeMode, _) {
        return MaterialApp.router(
          title: 'OWT',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
