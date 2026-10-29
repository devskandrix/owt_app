import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/top_notice.dart';
import '../../domain/entities/chat_message.dart';
import '../utils/chat_audio_player.dart';
import '../utils/chat_time.dart';
import 'chat_message_item.dart';

/// The rounded bar at the bottom of the chat: a purple camera button
/// (photos / videos), the text field, and a mic that records a voice note
/// while held (slide left to cancel). The send button replaces the mic
/// while there's text.
class ChatInputBar extends StatefulWidget {
  const ChatInputBar({
    super.key,
    required this.onSendText,
    required this.onSendMedia,
    required this.onTextChanged,
  });

  final void Function(String text) onSendText;
  final void Function(File file, ChatMessageType type, {int? durationSeconds})
  onSendMedia;
  final ValueChanged<String> onTextChanged;

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _controller = TextEditingController();
  final _picker = ImagePicker();
  AudioRecorder? _recorder;

  bool _hasText = false;

  /// Recording state: null when not recording.
  DateTime? _recordStart;
  Timer? _recordTicker;
  double _dragDx = 0;

  static const double _cancelDistance = 90;
  static const Duration _minRecording = Duration(seconds: 1);

  bool get _recording => _recordStart != null;

  @override
  void dispose() {
    _recordTicker?.cancel();
    _recorder?.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    widget.onSendText(text);
    _controller.clear();
    setState(() => _hasText = false);
  }

  // -------------------------------------------------------------------
  // Photos & videos
  // -------------------------------------------------------------------

  Future<void> _pickMedia() async {
    final source = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: context.appColors.background,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text(AppStrings.takePhoto),
              onTap: () => Navigator.pop(context, 'camera'),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text(AppStrings.chatChooseMedia),
              onTap: () => Navigator.pop(context, 'library'),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    try {
      final XFile? file = source == 'camera'
          ? await _picker.pickImage(
              source: ImageSource.camera,
              imageQuality: 85,
              maxWidth: 2048,
            )
          : await _picker.pickMedia(imageQuality: 85, maxWidth: 2048);
      if (file == null) return;
      final isVideo = RegExp(
        r'\.(mp4|mov|m4v|3gp|webm)$',
        caseSensitive: false,
      ).hasMatch(file.path);
      widget.onSendMedia(
        File(file.path),
        isVideo ? ChatMessageType.video : ChatMessageType.image,
      );
    } catch (_) {
      if (mounted) TopNotice.showError(context, AppStrings.somethingWentWrong);
    }
  }

  // -------------------------------------------------------------------
  // Voice notes
  // -------------------------------------------------------------------

  Future<void> _startRecording() async {
    final recorder = _recorder ??= AudioRecorder();
    if (!await recorder.hasPermission()) {
      if (mounted) TopNotice.showError(context, AppStrings.chatMicDenied);
      return;
    }
    await ChatAudioPlayer.stop();
    final dir = await getTemporaryDirectory();
    final path =
        '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
    await recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc),
      path: path,
    );
    if (!mounted) return;
    setState(() {
      _recordStart = DateTime.now();
      _dragDx = 0;
    });
    _recordTicker = Timer.periodic(
      const Duration(milliseconds: 250),
      (_) => setState(() {}),
    );
  }

  Future<void> _stopRecording({required bool send}) async {
    final start = _recordStart;
    _recordTicker?.cancel();
    _recordTicker = null;
    if (start == null) return;
    setState(() => _recordStart = null);
    final recorder = _recorder;
    if (recorder == null) return;
    final elapsed = DateTime.now().difference(start);
    if (!send || elapsed < _minRecording) {
      await recorder.cancel();
      return;
    }
    final path = await recorder.stop();
    if (path == null) return;
    widget.onSendMedia(
      File(path),
      ChatMessageType.audio,
      durationSeconds: (elapsed.inMilliseconds / 1000).round().clamp(1, 3600),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
        child: Container(
          constraints: const BoxConstraints(minHeight: 52),
          padding: const EdgeInsets.fromLTRB(5, 5, 6, 5),
          decoration: BoxDecoration(
            color: dark ? const Color(0xFF1C1D21) : const Color(0xFFF1F1F4),
            borderRadius: BorderRadius.circular(26),
          ),
          child: Row(
            // Keeps the buttons at the bottom when the text wraps.
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _CircleButton(
                icon: Icons.camera_alt,
                onTap: _recording ? null : _pickMedia,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _recording
                    ? _RecordingIndicator(
                        elapsed: DateTime.now().difference(_recordStart!),
                        dragDx: _dragDx,
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextField(
                          controller: _controller,
                          minLines: 1,
                          maxLines: 4,
                          textCapitalization: TextCapitalization.sentences,
                          style: AppTextStyles.chatBubble.copyWith(
                            color: colors.textPrimary,
                          ),
                          onChanged: (text) {
                            widget.onTextChanged(text);
                            final hasText = text.trim().isNotEmpty;
                            if (hasText != _hasText) {
                              setState(() => _hasText = hasText);
                            }
                          },
                          decoration: InputDecoration.collapsed(
                            hintText: AppStrings.chatInputHint,
                            hintStyle: AppTextStyles.chatBubble.copyWith(
                              color: colors.textMuted,
                            ),
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: 6),
              if (_hasText && !_recording)
                _CircleButton(icon: Icons.send_rounded, onTap: _send)
              else
                GestureDetector(
                  onTap: () =>
                      TopNotice.showError(context, AppStrings.chatHoldToRecord),
                  onLongPressStart: (_) => _startRecording(),
                  onLongPressMoveUpdate: (details) {
                    if (!_recording) return;
                    setState(
                      () => _dragDx = details.offsetFromOrigin.dx.clamp(
                        -_cancelDistance,
                        0,
                      ),
                    );
                    if (_dragDx <= -_cancelDistance) {
                      _stopRecording(send: false);
                    }
                  },
                  onLongPressEnd: (_) => _stopRecording(send: true),
                  child: Container(
                    width: 42,
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _recording ? AppColors.dangerRed : null,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.mic_none_rounded,
                      size: 24,
                      color: _recording ? Colors.white : colors.textPrimary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: const BoxDecoration(
          color: ChatColors.sent,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 20, color: Colors.white),
      ),
    );
  }
}

/// Red dot, elapsed time and "‹ Slide to cancel" while recording.
class _RecordingIndicator extends StatelessWidget {
  const _RecordingIndicator({required this.elapsed, required this.dragDx});

  final Duration elapsed;
  final double dragDx;

  @override
  Widget build(BuildContext context) {
    final muted = context.appColors.textMuted;
    return SizedBox(
      height: 42,
      child: Row(
        children: [
          const Icon(Icons.circle, size: 10, color: AppColors.dangerRed),
          const SizedBox(width: 8),
          Text(
            ChatTime.duration(elapsed.inSeconds),
            style: AppTextStyles.chatBubble.copyWith(
              color: context.appColors.textPrimary,
            ),
          ),
          const Spacer(),
          Transform.translate(
            offset: Offset(dragDx, 0),
            child: Text(
              '‹ ${AppStrings.chatSlideToCancel}',
              style: AppTextStyles.chatTime.copyWith(color: muted),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
