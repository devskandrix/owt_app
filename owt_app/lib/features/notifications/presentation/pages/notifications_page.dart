import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/notification_header.dart';
import '../widgets/notification_tile.dart';

/// "Notification" screen: a list of unread-notification rows. Page-level
/// chrome (background, text) is theme-aware, matching the rest of the
/// app's non-photo screens — Figma only shows a dark reference, but this
/// isn't a full-bleed photo screen, so it follows the same light/dark rule
/// as Dashboard, Search, Profile and Settings.
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  static const _notificationCount = 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.background,
      body: SafeArea(
        child: Column(
          children: [
            NotificationHeader(onBack: () => Navigator.of(context).maybePop()),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _notificationCount,
                itemBuilder: (context, index) => const NotificationTile(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
