import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../di/injection_container.dart';
import '../network/env.dart';
import '../network/media_url.dart';
import '../storage/token_storage.dart';

/// One event received from the chat socket: its name and payload.
class ChatSocketEvent {
  const ChatSocketEvent(this.name, this.data);

  final String name;
  final dynamic data;
}

/// The app's single Socket.IO connection for real-time chat.
///
/// - [connect] once signed in (from Home); [disconnect] on sign-out.
/// - Each (re)connect sends the access token currently stored, so
///   reconnects after a token refresh use the new one.
/// - When `POST /auth/refresh` rotates the token, the socket reconnects
///   with it straight away ([TokenStorage.accessTokenChanges]).
/// - If the server drops the connection (e.g. the token expired), an
///   authenticated request is made first so the HTTP client refreshes the
///   session, then it reconnects.
///
/// Listens for `message:new`, `message:delivered`, `message:read` and
/// `typing:update` ([events]); [emit] sends `message:read` and
/// `typing:start` / `typing:stop`.
abstract final class ChatSocketService {
  static const messageNew = 'message:new';
  static const messageDelivered = 'message:delivered';
  static const messageRead = 'message:read';
  static const typingUpdate = 'typing:update';
  static const typingStart = 'typing:start';
  static const typingStop = 'typing:stop';

  static const _listened = [
    messageNew,
    messageDelivered,
    messageRead,
    typingUpdate,
  ];

  static io.Socket? _socket;
  static StreamSubscription<String>? _tokenSub;
  static _LifecycleObserver? _lifecycle;
  static bool _recovering = false;

  static final _events = StreamController<ChatSocketEvent>.broadcast();

  /// Every chat event from the server.
  static Stream<ChatSocketEvent> get events => _events.stream;

  /// Whether the socket is connected right now.
  static final ValueNotifier<bool> connected = ValueNotifier(false);

  /// Fires each time the socket (re)connects, so screens can reload what
  /// they may have missed while offline.
  static final _reconnects = StreamController<void>.broadcast();
  static Stream<void> get reconnects => _reconnects.stream;

  static void log(String message) {
    if (kDebugMode) debugPrint('[CHAT] $message');
  }

  /// Opens the connection if it isn't open already.
  static Future<void> connect() async {
    if (_socket != null) {
      if (!(_socket!.connected)) _socket!.connect();
      return;
    }
    if (await TokenStorage.readAccessToken() == null) return;

    final url = _socketUrl;
    final socket = io.io(
      url,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .enableReconnection()
          .enableForceNew()
          // Read on every (re)connect, so a refreshed token is used.
          .setAuthFn((callback) {
            TokenStorage.readAccessToken().then(
              (token) => callback({'token': token ?? ''}),
            );
          })
          .build(),
    );
    _socket = socket;

    socket
      ..onConnect((_) {
        log('connected');
        connected.value = true;
        _reconnects.add(null);
      })
      ..onDisconnect((reason) {
        log('disconnected: $reason');
        connected.value = false;
        // The server closed it (e.g. expired token): Socket.IO won't retry
        // on its own in that case.
        if (reason == 'io server disconnect') _recover();
      })
      ..onConnectError((error) {
        log('connect error: $error');
        connected.value = false;
        if ('$error'.toLowerCase().contains(
          RegExp('auth|token|jwt|expired|unauthori'),
        )) {
          _recover();
        }
      });
    for (final name in _listened) {
      socket.on(name, (data) {
        log('<- $name');
        _events.add(ChatSocketEvent(name, data));
      });
    }

    _tokenSub ??= TokenStorage.accessTokenChanges.listen((_) {
      if (_socket == null) return;
      log('token refreshed: reconnecting');
      _socket!
        ..disconnect()
        ..connect();
    });
    _lifecycle ??= _LifecycleObserver()..attach();

    log('connecting to $url');
    socket.connect();
  }

  /// [Env.socketUrl], with a `localhost` host moved onto [Env.baseUrl]'s
  /// host so a device can reach the server.
  static String get _socketUrl => resolveMediaUrl(Env.socketUrl);

  /// Sends [event] with [data] if connected. Returns whether it was sent.
  static bool emit(String event, Map<String, dynamic> data) {
    final socket = _socket;
    if (socket == null || !socket.connected) return false;
    log('-> $event');
    socket.emit(event, data);
    return true;
  }

  /// Closes the connection (sign-out).
  static void disconnect() {
    log('closing');
    _tokenSub?.cancel();
    _tokenSub = null;
    _lifecycle?.detach();
    _lifecycle = null;
    _socket?.dispose();
    _socket = null;
    connected.value = false;
  }

  /// Makes an authenticated request so a 401 refreshes the session
  /// (which reconnects through [TokenStorage.accessTokenChanges]); if the
  /// token was still fine, reconnects directly.
  static Future<void> _recover() async {
    if (_recovering || _socket == null) return;
    _recovering = true;
    try {
      final token = await TokenStorage.readAccessToken();
      if (token == null) return;
      await sl<Dio>().get<dynamic>(
        '/chats',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } catch (_) {
      // Refresh failed: the session-expired flow signs the user out.
    } finally {
      _recovering = false;
    }
    final socket = _socket;
    if (socket != null && !socket.connected) socket.connect();
  }
}

/// Reconnects when the app comes back to the foreground.
class _LifecycleObserver with WidgetsBindingObserver {
  void attach() => WidgetsBinding.instance.addObserver(this);

  void detach() => WidgetsBinding.instance.removeObserver(this);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) ChatSocketService.connect();
  }
}
