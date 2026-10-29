import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../domain/entities/chat_message.dart';
import '../utils/chat_time.dart';
import 'chat_message_item.dart';

/// A photo or video message: a rounded preview that opens full screen.
/// Shows the local file while it's still sending.
class ChatMediaBubble extends StatelessWidget {
  const ChatMediaBubble({super.key, required this.message});

  final ChatMessage message;

  static const double _width = 220;
  static const double _height = 260;

  void _open(BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => message.type == ChatMessageType.video
            ? _VideoViewer(message: message)
            : _PhotoViewer(message: message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isVideo = message.type == ChatMessageType.video;
    final sending = message.sendState == ChatSendState.sending;
    return GestureDetector(
      onTap: message.mediaUrl == null && message.localFilePath == null
          ? null
          : () => _open(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: _width,
          height: isVideo ? 160 : _height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(color: ChatColors.received(context)),
              if (!isVideo) _image(message, fit: BoxFit.cover),
              if (isVideo)
                Container(
                  color: Colors.black87,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.play_circle_fill_rounded,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
              if (isVideo && (message.durationSeconds ?? 0) > 0)
                Positioned(
                  right: 10,
                  bottom: 8,
                  child: Text(
                    ChatTime.duration(message.durationSeconds!),
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              if (sending)
                Container(
                  color: Colors.black38,
                  alignment: Alignment.center,
                  child: const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
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

Widget _image(ChatMessage message, {required BoxFit fit}) {
  final path = message.localFilePath;
  if (path != null && File(path).existsSync()) {
    return Image.file(File(path), fit: fit);
  }
  final url = message.mediaUrl;
  if (url == null) return const SizedBox.shrink();
  return Image.network(
    url,
    fit: fit,
    loadingBuilder: (context, child, progress) => progress == null
        ? child
        : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    errorBuilder: (context, error, stack) => const Center(
      child: Icon(Icons.broken_image_outlined, color: Colors.white54),
    ),
  );
}

class _PhotoViewer extends StatelessWidget {
  const _PhotoViewer({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: InteractiveViewer(
        maxScale: 4,
        child: Center(child: _image(message, fit: BoxFit.contain)),
      ),
    );
  }
}

class _VideoViewer extends StatefulWidget {
  const _VideoViewer({required this.message});

  final ChatMessage message;

  @override
  State<_VideoViewer> createState() => _VideoViewerState();
}

class _VideoViewerState extends State<_VideoViewer> {
  late final VideoPlayerController _controller;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    final path = widget.message.localFilePath;
    _controller = path != null && File(path).existsSync()
        ? VideoPlayerController.file(File(path))
        : VideoPlayerController.networkUrl(
            Uri.parse(widget.message.mediaUrl ?? ''),
          );
    _controller
        .initialize()
        .then((_) {
          if (!mounted) return;
          setState(() {});
          _controller.play();
        })
        .catchError((Object _) {
          if (mounted) setState(() => _failed = true);
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ready = _controller.value.isInitialized;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: _failed
            ? const Icon(Icons.error_outline, color: Colors.white54, size: 40)
            : !ready
            ? const CircularProgressIndicator(color: Colors.white)
            : GestureDetector(
                onTap: () => setState(
                  () => _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play(),
                ),
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      VideoPlayer(_controller),
                      VideoProgressIndicator(_controller, allowScrubbing: true),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
