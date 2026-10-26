import 'package:flutter/foundation.dart';

import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/notifications/presentation/cubit/unread_notifications_cubit.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../di/injection_container.dart';
import '../router/app_route.dart';
import '../router/app_router.dart';
import '../storage/token_storage.dart';
import 'auth_service.dart';
import 'push_notification_service.dart';
import 'zego_service.dart';

/// Ends the signed-in session on this device: signs out of Firebase /
/// Google (so the next Google sign-in shows the account picker), clears
/// the stored tokens and the cached profile, and returns to the splash
/// (login) screen.
///
/// Used by Settings → Log out ([logOut]) and when a 401 can't be resolved
/// by refreshing the session ([signOut], from `DioClient`).
abstract final class SessionService {
  /// The user chose to log out: revokes the refresh token server-side via
  /// `POST /auth/logout`, then signs out locally. The server call is best
  /// effort (capped at a few seconds) so being offline never blocks it.
  static Future<void> logOut() async {
    try {
      await sl<AuthRepository>().logout().timeout(const Duration(seconds: 5));
    } catch (_) {}
    await signOut();
  }

  /// Deactivates the account via `DELETE /users/me`. Throws a `Failure`
  /// if the call fails. Call [signOut] after it succeeds.
  static Future<void> deactivateAccount() =>
      sl<ProfileRepository>().deactivateAccount();

  /// Signs out on this device only. Used directly when the session has
  /// already expired, so there's nothing left to revoke server-side.
  static Future<void> signOut() async {
    try {
      // Firebase isn't initialized on web (see main.dart), and a failed
      // provider sign-out shouldn't stop the local logout.
      if (!kIsWeb) await AuthService.signOut();
    } catch (_) {}
    await ZegoService.logout();
    await PushNotificationService.deleteToken();
    await TokenStorage.clear();
    sl<ProfileCubit>().reset();
    sl<UnreadNotificationsCubit>().reset();
    AppRouter.router.goNamed(AppRoute.splash.name);
  }
}
