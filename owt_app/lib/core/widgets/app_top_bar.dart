import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../router/app_route.dart';
import '../theme/app_colors.dart';
import '../../gen/assets.gen.dart';

/// Centered "OWT" wordmark with a notification bell on the trailing edge.
/// Shared across screens that use the dashboard-style app shell (Home,
/// Search, ...).
class AppTopBar extends StatelessWidget {
  const AppTopBar({super.key});

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
          GestureDetector(
            onTap: () => context.pushNamed(AppRoute.notifications.name),
            child: SvgPicture.asset(
              Assets.icons.bell,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                context.appColors.textPrimary,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
