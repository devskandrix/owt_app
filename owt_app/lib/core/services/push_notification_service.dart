import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../features/notifications/domain/repositories/notifications_repository.dart';
import '../../features/notifications/presentation/cubit/unread_notifications_cubit.dart';
import '../../firebase_options.dart';
import '../di/injection_container.dart';
import '../router/app_route.dart';
import '../router/app_router.dart';
import '../storage/token_storage.dart';

/// Runs in its own isolate when a push arrives while the app is in the
/// background or killed. Messages with a `notification` block are shown by
/// the OS itself, so this only needs Firebase ready for any extra work.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

/// Firebase Cloud Messaging setup for Android and iOS.
///
/// - Background / killed: the OS shows the notification (Android uses the
///   [_channel] set as the default in AndroidManifest.xml).
/// - Foreground: iOS shows it natively (see
///   `setForegroundNotificationPresentationOptions`); Android doesn't show
///   FCM notifications while the app is open, so one is posted through
///   flutter_local_notifications.
/// - Tapping a notification opens the Notification screen.
/// - Every push also refreshes the bell's unread count.
abstract final class PushNotificationService {
  static final _messaging = FirebaseMessaging.instance;
  static final _local = FlutterLocalNotificationsPlugin();

  /// Must match `default_notification_channel_id` in AndroidManifest.xml.
  static const _channel = AndroidNotificationChannel(
    'owt_default',
    'Notifications',
    description: 'Likes, matches and club updates.',
    importance: Importance.high,
  );

  static bool _initialized = false;

  /// Set once permission + token are handled for this sign-in, so
  /// returning to Home doesn't redo it; cleared by [deleteToken].
  static bool _registered = false;

  /// Call once from `main()`, before `runApp`.
  static void registerBackgroundHandler() {
    if (kIsWeb) return;
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  /// Sets up listeners and the Android channel. Doesn't ask for permission
  /// (see [requestPermission]). Call after `runApp`.
  static Future<void> init() async {
    if (kIsWeb || _initialized) return;
    _initialized = true;

    await _local.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        // Permission is requested through FirebaseMessaging instead.
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (_) => _openNotifications(),
    );
    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((_) => _openNotifications());
    _messaging.onTokenRefresh.listen(_onToken);

    // The app was launched by tapping a notification while it was killed.
    final initial = await _messaging.getInitialMessage();
    if (initial != null) _openNotifications(coldStart: true);
  }

  /// Asks for permission to show notifications (iOS, and Android 13+),
  /// then fetches the FCM token and registers it with the backend. Called
  /// from Home, so it runs after every sign-in and on each app launch while
  /// signed in; later calls do nothing until the next sign-in.
  static Future<void> requestPermission() async {
    if (kIsWeb || _registered) return;
    _registered = true;
    final settings = await _messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.denied) return;
    try {
      // On iOS the APNs token must exist before an FCM token can be made.
      if (defaultTargetPlatform == TargetPlatform.iOS &&
          await _messaging.getAPNSToken() == null) {
        return;
      }
      final token = await _messaging.getToken();
      if (token != null) await _onToken(token);
    } catch (e) {
      debugPrint('FCM token unavailable: $e');
    }
  }

  /// Stops pushes to this device after sign-out.
  static Future<void> deleteToken() async {
    if (kIsWeb) return;
    _registered = false;
    try {
      await _messaging.deleteToken();
    } catch (_) {}
  }

  /// Sends [token] to `POST /users/me/device-token` (signed-in only).
  /// If it differs from the token last sent from this device, Firebase
  /// rotated it, so the old one goes along as `previousToken` and the
  /// server drops it.
  static Future<void> _onToken(String token) async {
    if (!await TokenStorage.hasSession()) return;
    final previous = await TokenStorage.readFcmToken();
    try {
      await sl<NotificationsRepository>().registerDeviceToken(
        token: token,
        platform: switch (defaultTargetPlatform) {
          TargetPlatform.android => 'ANDROID',
          TargetPlatform.iOS => 'IOS',
          _ => null,
        },
        previousToken: previous != null && previous != token ? previous : null,
      );
      await TokenStorage.saveFcmToken(token);
    } catch (e) {
      // Retried on the next app launch / sign-in.
      debugPrint('Device token not registered: $e');
    }
  }

  static Future<void> _onForegroundMessage(RemoteMessage message) async {
    sl<UnreadNotificationsCubit>().refresh();

    // iOS already shows it (presentation options above).
    if (defaultTargetPlatform != TargetPlatform.android) return;
    final notification = message.notification;
    if (notification == null) return;
    await _local.show(
      id: message.messageId?.hashCode ?? notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  /// Shows the Notification screen if the user is signed in. On a cold
  /// start it waits for the first frame and lands on Dashboard first, so
  /// back still leads somewhere.
  static Future<void> _openNotifications({bool coldStart = false}) async {
    if (!await TokenStorage.hasSession()) return;
    sl<UnreadNotificationsCubit>().refresh();
    if (coldStart) {
      await WidgetsBinding.instance.endOfFrame;
      AppRouter.router.goNamed(AppRoute.dashboard.name);
    }
    AppRouter.router.pushNamed(AppRoute.notifications.name);
  }
}
