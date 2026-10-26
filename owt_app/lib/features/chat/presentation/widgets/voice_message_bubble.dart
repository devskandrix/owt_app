import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zego_zimkit/zego_zimkit.dart';
// ZIMKit's audio player isn't part of its public API. Safe while zego_zimkit
// is pinned to an exact version (see pubspec.yaml).
// ignore: implementation_imports
import 'package:zego_zimkit/src/services/audio/core.dart';
// ignore: implementation_imports
import 'package:zego_zimkit/src/services/audio/data.dart';

import '../../../../core/theme/app_colors.dart';
import 'chat_message_item.dart';

/// A voice message in the design's style: a white play button, a waveform
/// that fills in as it plays, and the length ("00:16").
///
/// Plays through ZIMKit's audio player, the same one its own voice bubble
/// uses, so only one voice message plays at a time.
class VoiceMessageBubble extends StatefulWidget {
  const VoiceMessageBubble({super.key, required this.message});

  final ZIMKitMessage message;

  @override
  State<VoiceMessageBubble> createState() => _VoiceMessageBubbleState();
}

class _VoiceMessageBubbleState extends State<VoiceMessageBubble> {
  ZIMKitAudioInstance get _player => ZIMKitAudioInstance();

  int get _id => widget.message.info.messageID;

  ZIMKitMessageAudioContent get _audio => widget.message.audioContent!;

  bool _isPlayingThis(ZIMKitAudioPlayStatus status) =>
      status.isPlaying && status.id == _id;

  @override
  void dispose() {
    // Stop this message if it's still playing when it scrolls away.
    if (_player.data.playStatusNotifier.value.id == _id) {
      _player.stopPlay();
    }
    super.dispose();
  }

  void _toggle() {
    final path = _audio.fileLocalPath;
    // Still downloading.
    if (path.isEmpty) return;
    if (_isPlayingThis(_player.data.playStatusNotifier.value)) {
      _player.stopPlay();
    } else {
      _player.startPlay(_id, path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mine = widget.message.isMine;
    final foreground = mine ? Colors.white : context.appColors.textPrimary;
    final seconds = _audio.audioDuration;
    final maxWidth = MediaQuery.sizeOf(context).width * 0.62;
    // Longer messages get a wider bubble, like the design's 16s one.
    final width = (150 + seconds * 5).clamp(150, maxWidth).toDouble();

    return GestureDetector(
      onTap: _toggle,
      child: Container(
        width: width,
        height: 38,
        padding: const EdgeInsets.only(left: 12, right: 14),
        decoration: BoxDecoration(
          color: mine ? ChatColors.sent : ChatColors.received(context),
          borderRadius: BorderRadius.circular(19),
        ),
        child: ValueListenableBuilder<ZIMKitAudioPlayStatus>(
          valueListenable: _player.data.playStatusNotifier,
          builder: (context, status, _) {
            final playing = _isPlayingThis(status);
            return Row(
              children: [
                _PlayButton(
                  playing: playing,
                  loading: _audio.fileLocalPath.isEmpty,
                  mine: mine,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: playing
                      ? ValueListenableBuilder<int>(
                          valueListenable: _player.data.playProcessNotifier,
                          builder: (context, playedMs, _) => _Waveform(
                            seed: _id,
                            progress: seconds == 0
                                ? 0
                                : playedMs / (seconds * 1000),
                            color: foreground,
                          ),
                        )
                      : _Waveform(seed: _id, progress: 0, color: foreground),
                ),
                const SizedBox(width: 12),
                Text(
                  _format(seconds),
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: foreground,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  static String _format(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({
    required this.playing,
    required this.loading,
    required this.mine,
  });

  final bool playing;
  final bool loading;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    // White circle with a purple icon on our bubbles; reversed on theirs.
    final circle = mine ? Colors.white : ChatColors.sent;
    final icon = mine ? ChatColors.sent : Colors.white;
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(color: circle, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: loading
          ? SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(strokeWidth: 1.5, color: icon),
            )
          : Icon(
              playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 16,
              color: icon,
            ),
    );
  }
}

/// Vertical bars of varied height. Bars before [progress] (0–1) are solid;
/// the rest are faded. Heights come from [seed], so each message keeps the
/// same shape.
class _Waveform extends StatelessWidget {
  const _Waveform({
    required this.seed,
    required this.progress,
    required this.color,
  });

  final int seed;
  final double progress;
  final Color color;

  static const double _barWidth = 2;
  static const double _gap = 3;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = (constraints.maxWidth / (_barWidth + _gap)).floor();
        final random = Random(seed);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var i = 0; i < count; i++)
              Container(
                width: _barWidth,
                // 4–16pt, like the design's mix of dots and tall bars.
                height: 4 + random.nextInt(13).toDouble(),
                decoration: BoxDecoration(
                  color: i / count < progress
                      ? color
                      : color.withValues(alpha: progress > 0 ? 0.45 : 1),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
          ],
        );
      },
    );
  }
}
