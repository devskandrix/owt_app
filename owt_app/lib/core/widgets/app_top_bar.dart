import 'package:flutter/material.dart';

import '../../features/notifications/presentation/widgets/notification_bell.dart';
import '../../gen/assets.gen.dart';

/// Centered "OWT" wordmark with a notification bell on the trailing edge.
/// Shared across screens that use the dashboard-style app shell (Home,
/// Search, ...).
class AppTopBar extends StatelessWidget {
  const AppTopBar({super.key, this.refreshNotificationCount = true});

  /// Whether the bell fetches the unread count
  /// (`GET /notifications/unread-count`) when this bar appears.
  final bool refreshNotificationCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Row(
        children: [
          const SizedBox(width: 24),
          Expanded(
            child: Center(
              child: Assets.images.owtLogoPng.image(
                height: 28,
                fit: BoxFit.contain,
              ),
            ),
          ),
          NotificationBell(refreshCount: refreshNotificationCount),
        ],
      ),
    );
  }
}
