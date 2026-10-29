import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Which voice note is playing, and how far.
class ChatAudioStatus {
  const ChatAudioStatus({this.key, this.playing = false, this.position});

  /// The playing message's key; null when nothing is loaded.
  final String? key;
  final bool playing;
  final Duration? position;
}

/// One player shared by every voice note, so starting one stops the
/// other. Plays a local file when there is one (just recorded), otherwise
/// the message's URL.
abstract final class ChatAudioPlayer {
  static AudioPlayer? _player;
  static final List<StreamSubscription<dynamic>> _subs = [];

  static final ValueNotifier<ChatAudioStatus> status = ValueNotifier(
    const ChatAudioStatus(),
  );

  static AudioPlayer get _instance {
    final existing = _player;
    if (existing != null) return existing;
    final player = AudioPlayer();
    _subs
      ..add(
        player.onPositionChanged.listen((position) {
          final s = status.value;
          status.value = ChatAudioStatus(
            key: s.key,
            playing: s.playing,
            position: position,
          );
        }),
      )
      ..add(
        player.onPlayerComplete.listen(
          (_) => status.value = const ChatAudioStatus(),
        ),
      );
    return _player = player;
  }

  /// Plays [key]'s audio, or stops it if it's the one playing.
  static Future<void> toggle(
    String key, {
    String? localPath,
    String? url,
  }) async {
    final player = _instance;
    if (status.value.key == key && status.value.playing) {
      await stop();
      return;
    }
    final source = localPath != null
        ? DeviceFileSource(localPath)
        : url != null
        ? UrlSource(url)
        : null;
    if (source == null) return;
    await player.stop();
    status.value = ChatAudioStatus(key: key, playing: true);
    try {
      await player.play(source);
    } catch (_) {
      status.value = const ChatAudioStatus();
      rethrow;
    }
  }

  static Future<void> stop() async {
    status.value = const ChatAudioStatus();
    await _player?.stop();
  }

  /// Stops [key] if it's the one playing (its bubble left the screen).
  static void stopIfPlaying(String key) {
    if (status.value.key == key) stop();
  }
}
