import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/router/app_route.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../gen/assets.gen.dart';
import '../cubit/unread_notifications_cubit.dart';

/// The bell icon that opens the Notification screen, with a red badge for
/// unread notifications (`GET /notifications/unread-count`). Refreshes the
/// count when it appears and when coming back from the screen, unless
/// [refreshCount] is false.
class NotificationBell extends StatefulWidget {
  const NotificationBell({super.key, this.color, this.refreshCount = true});

  /// Icon color; defaults to the theme's primary text color.
  final Color? color;

  /// Whether this bell fetches the unread count. When false it shows the
  /// count last loaded elsewhere (e.g. on Home) and makes no request.
  final bool refreshCount;

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  final UnreadNotificationsCubit _unread = sl<UnreadNotificationsCubit>();

  @override
  void initState() {
    super.initState();
    if (widget.refreshCount) _unread.refresh();
  }

  Future<void> _open() async {
    await context.pushNamed(AppRoute.notifications.name);
    if (widget.refreshCount) _unread.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _open,
      behavior: HitTestBehavior.opaque,
      child: BlocBuilder<UnreadNotificationsCubit, int>(
        bloc: _unread,
        builder: (context, count) => Stack(
          clipBehavior: Clip.none,
          children: [
            SvgPicture.asset(
              Assets.icons.bell,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                widget.color ?? context.appColors.textPrimary,
                BlendMode.srcIn,
              ),
            ),
            if (count > 0)
              Positioned(
                top: -4,
                right: -6,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 16),
                  height: 16,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.dangerRed,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    count > 99 ? '99+' : '$count',
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
