import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/chat/presentation/models/chat_args.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/chat/presentation/pages/messages_page.dart';
import '../../features/add_photos/presentation/pages/add_photos_page.dart';
import '../../features/create_account/presentation/pages/create_account_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/interests/presentation/pages/interests_page.dart';
import '../../features/friends/domain/entities/friend.dart';
import '../../features/friends/presentation/pages/friend_profile_page.dart';
import '../../features/friends/presentation/pages/friends_page.dart';
import '../../features/likes/presentation/pages/likes_page.dart';
import '../../features/likes/presentation/pages/user_detail_page.dart';
import '../../features/match/presentation/models/match_club.dart';
import '../../features/match/presentation/pages/match_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/phone_number/presentation/pages/phone_number_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/about/presentation/pages/about_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/verification/presentation/pages/verification_page.dart';
import '../storage/token_storage.dart';
import 'app_route.dart';

abstract final class AppRouter {
  /// The root navigator. ZEGOCLOUD's incoming-call screen is pushed on it
  /// (see ZegoService), so it can appear over any screen.
  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
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
        // extra: true when editing from Profile.
        builder: (context, state) =>
            AddPhotosPage(isEditing: state.extra == true),
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
        path: AppRoute.userDetail.path,
        name: AppRoute.userDetail.name,
        builder: (context, state) =>
            UserDetailPage(args: state.extra! as UserDetailArgs),
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
        path: AppRoute.friends.path,
        name: AppRoute.friends.name,
        builder: (context, state) => const FriendsPage(),
      ),
      GoRoute(
        path: AppRoute.friendProfile.path,
        name: AppRoute.friendProfile.name,
        // extra: the tapped [Friend].
        builder: (context, state) {
          final friend = state.extra! as Friend;
          return FriendProfilePage(
            matchId: friend.matchId,
            name: friend.name,
            initial: friend.profile,
          );
        },
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
          child: MatchPage(club: state.extra as MatchClub?),
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
        path: AppRoute.about.path,
        name: AppRoute.about.name,
        builder: (context, state) => const AboutPage(),
      ),
      GoRoute(
        path: AppRoute.messages.path,
        name: AppRoute.messages.name,
        builder: (context, state) => const MessagesPage(),
      ),
      GoRoute(
        path: AppRoute.chat.path,
        name: AppRoute.chat.name,
        // extra: the [ChatArgs] of who the chat is with.
        builder: (context, state) => ChatPage(args: state.extra! as ChatArgs),
      ),
      GoRoute(
        path: AppRoute.notifications.path,
        name: AppRoute.notifications.name,
        builder: (context, state) => const NotificationsPage(),
      ),
    ],
  );
}
