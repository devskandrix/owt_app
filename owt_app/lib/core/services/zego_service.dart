import 'package:flutter/foundation.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../../features/chat/domain/entities/zego_token.dart';
import '../../features/chat/domain/usecases/get_zego_token.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../di/injection_container.dart';
import '../network/env.dart';
import '../router/app_router.dart';
import '../usecase/usecase.dart';

/// ZEGOCLOUD voice / video calls (Call Kit). Chat itself runs on our own
/// backend (see `ChatSocketService`); ZEGOCLOUD is only used for calls.
///
/// - [init] once at startup.
/// - [login] once signed in (from Home): signs in as the user's own
///   id / name and starts listening for incoming calls.
/// - [logout] on sign-out.
///
/// Everything is a no-op when `ZEGO_APP_ID` isn't in `.env` (see
/// [isAvailable]), and on web.
///
/// Two sign-in modes (see `Env.zegoUseToken`):
/// - AppSign (development, project in Testing): `ZEGO_APP_SIGN` in `.env`.
/// - Token (live): a token from `GET /zego/token`, renewed before it
///   expires. Used when there's no AppSign or `ZEGO_USE_TOKEN=true`.
abstract final class ZegoService {
  static bool _initialized = false;

  /// The signed-in ZEGOCLOUD user id, or null when not logged in.
  static String? _userId;

  /// The ZEGOCLOUD user id for one of our backend user ids. ZEGOCLOUD
  /// allows at most 32 characters, and our ids are 36-character UUIDs, so
  /// the hyphens are dropped (leaving exactly 32). Use this everywhere an
  /// id goes to ZEGOCLOUD: sign-in and calls.
  static String idFor(String backendUserId) =>
      backendUserId.replaceAll('-', '');

  static bool get isAvailable => !kIsWeb && Env.hasZego;

  /// The AppSign to use: empty in token mode.
  static String get _appSign => Env.zegoUseToken ? '' : Env.zegoAppSign;

  /// Fetches a token from `GET /zego/token`; null (and logged) on failure.
  static Future<ZegoToken?> _fetchToken() async {
    try {
      final token = await sl<GetZegoToken>()(const NoParams());
      log('token: received, expires ${token.expiresAt.toLocal()}');
      return token;
    } catch (e) {
      log('token: request failed: $e');
      return null;
    }
  }

  /// The renewal in progress, so overlapping expiry warnings share one.
  static Future<void>? _renewing;

  /// Token mode: gets a fresh token and hands it to ZEGOCLOUD before the
  /// current one expires: for call invitations, and for the call
  /// in progress, if any. If it fails, the connection drops when the token
  /// expires and the next [login] signs in again with a new one.
  static Future<void> _renewToken() =>
      _renewing ??= _doRenewToken().whenComplete(() => _renewing = null);

  static Future<void> _doRenewToken() async {
    if (_userId == null) return;
    final token = await _fetchToken();
    if (token == null) return;
    final result = await ZegoUIKitSignalingPlugin().renewToken(token.token);
    log(
      result.error == null
          ? 'token: renewed'
          : 'token: renew failed: ${result.error}',
    );
    try {
      // Only matters during a call; harmless otherwise.
      await ZegoUIKit().renewRoomToken(token.token);
    } catch (_) {}
  }

  /// Prints a `[ZEGO]` line to the console in debug builds (release builds
  /// stay quiet). ZEGOCLOUD's own SDK logs go to files on the device, so
  /// these are the readable trail of call events. Filter the
  /// console by `[ZEGO]` to see only them.
  static void log(String message) {
    if (kDebugMode) debugPrint('[ZEGO] $message');
  }

  /// Whether calls are ready for the signed-in user.
  static bool get isLoggedIn => _userId != null;

  /// Call once from `main()`, before `runApp`.
  static Future<void> init() async {
    if (!isAvailable || _initialized) return;
    _initialized = true;
    // In token mode the AppSign must not be used at all.
    await ZegoUIKitSignalingPlugin().init(
      appID: Env.zegoAppId,
      appSign: _appSign,
    );
    log(
      'init: appID ${Env.zegoAppId}, '
      '${Env.zegoUseToken ? 'token' : 'AppSign'} mode',
    );
    ZegoUIKitSignalingPlugin().getConnectionStateChangedEventStream().listen((
      event,
    ) {
      log('connection: ${event.state.name}');
      // If the connection drops for good (e.g. the same account signs in
      // on another device), stop treating calls as ready, so the next
      // [login] connects again.
      if (event.state == ZegoSignalingPluginConnectionState.disconnected &&
          _userId != null) {
        _userId = null;
      }
    });
    ZegoUIKitSignalingPlugin().getErrorEventStream().listen(
      (event) => log('error ${event.code}: ${event.message}'),
    );
    ZegoUIKitSignalingPlugin().getTokenWillExpireEventStream().listen((event) {
      log('token expires in ${event.second}s');
      if (Env.zegoUseToken) _renewToken();
    });
    // Lets the incoming-call screen appear over whatever is showing.
    ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(
      AppRouter.rootNavigatorKey,
    );
  }

  /// The sign-in in progress, so overlapping callers (Home starting it,
  /// then a chat opening before it finishes) wait for the same
  /// one instead of signing in twice at once.
  static Future<void>? _loggingIn;

  /// Signs into calls as the current user. Safe to call more
  /// than once; does nothing if already logged in as that user. Check
  /// [isLoggedIn] afterwards to know whether it worked.
  static Future<void> login() =>
      _loggingIn ??= _login().whenComplete(() => _loggingIn = null);

  static Future<void> _login() async {
    if (!isAvailable || !_initialized) return;
    final profileCubit = sl<ProfileCubit>();
    await profileCubit.ensureLoaded();
    final profile = profileCubit.state.profile;
    if (profile == null) {
      log('login: skipped, profile not loaded');
      return;
    }
    final zegoId = idFor(profile.id);
    if (_userId == zegoId) {
      log('login: already signed in as $zegoId');
      return;
    }
    if (_userId != null) await logout();

    log('login: signing in as $zegoId (${profile.fullName})');
    try {
      ZegoToken? token;
      if (Env.zegoUseToken) {
        token = await _fetchToken();
        if (token == null) return;
        // Sign in to the signaling plugin with the token first; the call
        // service then reuses that session.
        final result = await ZegoUIKitSignalingPlugin().connectUser(
          id: zegoId,
          name: profile.fullName,
          token: token.token,
        );
        if (result.error != null) {
          log('login: token sign-in failed: ${result.error}');
          return;
        }
        log('login: signed in with token');
      }

      log('login: starting call service');
      await ZegoUIKitPrebuiltCallInvitationService().init(
        appID: Env.zegoAppId,
        appSign: _appSign,
        token: token?.token ?? '',
        userID: zegoId,
        userName: profile.fullName,
        plugins: [ZegoUIKitSignalingPlugin()],
        // Don't ask for camera / microphone at sign-in. The caller is
        // asked when tapping a call button (see CallPermissions); the
        // receiver is asked by the call screen when they answer, for only
        // what that call type uses.
        //
        // "Display over other apps" (Android only; skipped on iOS) is asked
        // for here: without it, ZEGOCLOUD doesn't show the incoming-call
        // notification while the app is in the background.
        config: ZegoCallInvitationConfig(
          permissions: const [ZegoCallInvitationPermission.systemAlertWindow],
        ),
        invitationEvents: _callInvitationLogs(),
        events: ZegoUIKitPrebuiltCallEvents(
          onCallEnd: (event, defaultAction) {
            log('call ended: ${event.reason.name}');
            // Closes the call screen, as the kit would without this hook.
            defaultAction();
          },
          onError: (error) => log('call error ${error.code}: ${error.message}'),
          room: ZegoCallRoomEvents(
            // Token mode: renew during a long call too.
            onTokenExpired: (remainingSeconds) {
              log('call token expires in ${remainingSeconds}s');
              if (Env.zegoUseToken) _renewToken();
              return null;
            },
          ),
        ),
      );
      _userId = zegoId;
      log('login: done, calls ready');
    } catch (e) {
      log('login: failed: $e');
    }
  }

  /// Signs out and stops receiving calls.
  static Future<void> logout() async {
    if (!isAvailable || _userId == null) return;
    log('logout: $_userId');
    _userId = null;
    try {
      await ZegoUIKitPrebuiltCallInvitationService().uninit();
      await ZegoUIKitSignalingPlugin().disconnectUser();
      log('logout: done');
    } catch (e) {
      log('logout: failed: $e');
    }
  }

  /// Logs each step of a call invitation, both directions.
  static ZegoUIKitPrebuiltCallInvitationEvents _callInvitationLogs() {
    String type(bool video) => video ? 'video' : 'voice';
    return ZegoUIKitPrebuiltCallInvitationEvents(
      onOutgoingCallSent: (callID, caller, callType, callees, customData) =>
          log(
            'call $callID: ${callType.name} call sent to '
            '${callees.map((c) => c.id).join(', ')}',
          ),
      onOutgoingCallAccepted: (callID, callee) =>
          log('call $callID: accepted by ${callee.id}'),
      onOutgoingCallDeclined: (callID, callee, customData) =>
          log('call $callID: declined by ${callee.id}'),
      onOutgoingCallRejectedCauseBusy: (callID, callee, customData) =>
          log('call $callID: ${callee.id} is busy'),
      onOutgoingCallTimeout: (callID, callees, isVideoCall) =>
          log('call $callID: ${type(isVideoCall)} call not answered'),
      onIncomingCallReceived: (callID, caller, callType, callees, customData) =>
          log('call $callID: incoming ${callType.name} call from ${caller.id}'),
      onIncomingCallCanceled: (callID, caller, customData) =>
          log('call $callID: cancelled by ${caller.id}'),
      onIncomingCallTimeout: (callID, caller) =>
          log('call $callID: missed call from ${caller.id}'),
      onError: (error) =>
          log('call invitation error ${error.code}: ${error.message}'),
    );
  }
}
