import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum _TopNoticeType { success, error }

/// A brief message banner pinned to the top of the screen, below the
/// status bar. Used instead of a bottom [SnackBar] so messages don't get
/// hidden behind the keyboard or the bottom action button on the auth
/// screens.
abstract final class TopNotice {
  static OverlayEntry? _entry;
  static Timer? _timer;

  static void showSuccess(BuildContext context, String message) =>
      _show(context, message, _TopNoticeType.success);

  static void showError(BuildContext context, String message) =>
      _show(context, message, _TopNoticeType.error);

  static void _show(BuildContext context, String message, _TopNoticeType type) {
    _entry?.remove();
    _timer?.cancel();

    final overlay = Overlay.of(context, rootOverlay: true);
    final entry = OverlayEntry(
      builder: (_) => _TopNoticeBanner(message: message, type: type),
    );
    _entry = entry;
    overlay.insert(entry);

    _timer = Timer(const Duration(seconds: 3), () {
      _entry?.remove();
      _entry = null;
    });
  }
}

class _TopNoticeBanner extends StatelessWidget {
  const _TopNoticeBanner({required this.message, required this.type});

  final String message;
  final _TopNoticeType type;

  @override
  Widget build(BuildContext context) {
    final color = type == _TopNoticeType.success
        ? AppColors.successGreen
        : AppColors.dangerRed;
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 200),
          builder: (context, value, child) => Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, (1 - value) * -12),
              child: child,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: 'Mulish',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
