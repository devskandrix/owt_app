import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// A round profile photo, or a person icon when there's no photo or it
/// fails to load.
class ChatAvatar extends StatelessWidget {
  const ChatAvatar({super.key, required this.url, required this.size});

  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final fallback = Container(
      width: size,
      height: size,
      color: colors.inputBorder,
      alignment: Alignment.center,
      child: Icon(Icons.person, size: size * 0.55, color: colors.textMuted),
    );
    final url = this.url;
    return ClipOval(
      child: url == null || url.isEmpty
          ? fallback
          : Image.network(
              url,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => fallback,
            ),
    );
  }
}
