import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/top_notice.dart';
import '../../domain/entities/chat_message.dart';
import '../utils/chat_audio_player.dart';
import '../utils/chat_time.dart';
import 'chat_message_item.dart';

/// A voice message in the design's style: a white play button, a waveform
/// that fills in as it plays, and the length ("00:16").
///
/// Plays through [ChatAudioPlayer], shared by every voice message, so only
/// one plays at a time.
class VoiceMessageBubble extends StatefulWidget {
  const VoiceMessageBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  State<VoiceMessageBubble> createState() => _VoiceMessageBubbleState();
}

class _VoiceMessageBubbleState extends State<VoiceMessageBubble> {
  bool _loading = false;

  String get _key => widget.message.key;

  @override
  void dispose() {
    // Stop this message if it's still playing when it scrolls away.
    ChatAudioPlayer.stopIfPlaying(_key);
    super.dispose();
  }

  Future<void> _toggle() async {
    final message = widget.message;
    setState(() => _loading = true);
    try {
      await ChatAudioPlayer.toggle(
        _key,
        localPath: message.localFilePath,
        url: message.mediaUrl,
      );
    } catch (_) {
      if (mounted) TopNotice.showError(context, AppStrings.chatPlaybackFailed);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mine = widget.message.isMine;
    final foreground = mine ? Colors.white : context.appColors.textPrimary;
    final seconds = widget.message.durationSeconds ?? 0;
    final maxWidth = MediaQuery.sizeOf(context).width * 0.62;
    // Longer messages get a wider bubble, like the design's 16s one.
    final width = (150 + seconds * 5).clamp(150, maxWidth).toDouble();
    final seed = _key.hashCode;

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
        child: ValueListenableBuilder<ChatAudioStatus>(
          valueListenable: ChatAudioPlayer.status,
          builder: (context, status, _) {
            final playing = status.key == _key && status.playing;
            final played = playing ? status.position : null;
            final progress = played == null || seconds == 0
                ? 0.0
                : (played.inMilliseconds / (seconds * 1000)).clamp(0.0, 1.0);
            return Row(
              children: [
                _PlayButton(playing: playing, loading: _loading, mine: mine),
                const SizedBox(width: 12),
                Expanded(
                  child: _Waveform(
                    seed: seed,
                    progress: progress,
                    color: foreground,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  ChatTime.duration(
                    played != null ? played.inSeconds : seconds,
                  ),
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
