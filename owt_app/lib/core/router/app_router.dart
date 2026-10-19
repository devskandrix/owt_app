import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/add_photos/presentation/pages/add_photos_page.dart';
import '../../features/create_account/presentation/pages/create_account_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/interests/presentation/pages/interests_page.dart';
import '../../features/likes/presentation/pages/likes_page.dart';
import '../../features/match/presentation/pages/match_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/phone_number/presentation/pages/phone_number_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/verification/presentation/pages/verification_page.dart';
import '../storage/token_storage.dart';
import 'app_route.dart';

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoute.splash.path,
    // Splash doubles as the login screen. If a session was already saved on
    // a previous launch (see TokenStorage.hasSession), skip straight to the
    // dashboard instead of asking the user to sign in again.
    redirect: (context, state) async {
      if (state.matchedLocation != AppRoute.splash.path) return null;
      final loggedIn = await TokenStorage.hasSession();
      return loggedIn ? AppRoute.dashboard.path : null;
    },
    routes: [
      GoRoute(
        path: AppRoute.splash.path,
        name: AppRoute.splash.name,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoute.phoneNumber.path,
        name: AppRoute.phoneNumber.name,
        builder: (context, state) => const PhoneNumberPage(),
      ),
      GoRoute(
        path: AppRoute.verification.path,
        name: AppRoute.verification.name,
        builder: (context, state) =>
            VerificationPage(phoneNumber: state.extra! as String),
      ),
      GoRoute(
        path: AppRoute.createAccount.path,
        name: AppRoute.createAccount.name,
        builder: (context, state) => const CreateAccountPage(),
      ),
      GoRoute(
        path: AppRoute.interests.path,
        name: AppRoute.interests.name,
        builder: (context, state) => const InterestsPage(),
      ),
      GoRoute(
        path: AppRoute.addPhotos.path,
        name: AppRoute.addPhotos.name,
        builder: (context, state) => const AddPhotosPage(),
      ),
      GoRoute(
        path: AppRoute.dashboard.path,
        name: AppRoute.dashboard.name,
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: AppRoute.likes.path,
        name: AppRoute.likes.name,
        builder: (context, state) => const LikesPage(),
      ),
      GoRoute(
        path: AppRoute.search.path,
        name: AppRoute.search.name,
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        path: AppRoute.profile.path,
        name: AppRoute.profile.name,
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: AppRoute.match.path,
        name: AppRoute.match.name,
        // Custom transition (no CupertinoPageTransitionsBuilder) so this
        // route doesn't get iOS's edge-swipe-to-pop gesture, which would
        // otherwise fight the card's own right-swipe ("Like") gesture for
        // any drag starting near the left edge.
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const MatchPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: AppRoute.settings.path,
        name: AppRoute.settings.name,
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: AppRoute.notifications.path,
        name: AppRoute.notifications.name,
        builder: (context, state) => const NotificationsPage(),
      ),
    ],
  );
}
