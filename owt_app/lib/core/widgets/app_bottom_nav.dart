import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../gen/assets.gen.dart';
import '../router/app_route.dart';
import '../theme/app_gradients.dart';

/// The tab highlighted in [AppBottomNav].
enum AppNavTab { home, likes, profile }

/// Persistent bottom navigation bar: Home, Likes, a highlighted "Post"
/// action, and the profile avatar. Icons are theme-invariant (fixed
/// gradient/gray fills baked into the source SVGs), since the bar itself
/// is a fixed dark dock in both themes. Shared across screens that use the
/// dashboard-style app shell (Home, Search, Profile, ...).
///
/// The [active] tab gets its gradient-filled icon (or, for Profile, a
/// gradient ring around the avatar); the others show their muted icons.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, this.active = AppNavTab.home});

  final AppNavTab active;

  @override
  Widget build(BuildContext context) {
    final profileActive = active == AppNavTab.profile;
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF17181A),
        border: Border(top: BorderSide(color: Color(0xFF17181A))),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: SafeArea(
        top: false,
        // Bounds the row to its tallest icon (the 28px avatar). Without this,
        // Scaffold hands bottomNavigationBar a loose constraint up to the
        // full screen height, and Center (inside each Expanded) always
        // expands to fill bounded constraints — so the whole bar would
        // balloon to fill the entire screen instead of hugging its content.
        child: SizedBox(
          height: 28,
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () => context.goNamed(AppRoute.dashboard.name),
                    child: SvgPicture.asset(
                      active == AppNavTab.home ? Assets.icons.navHome : Assets.icons.navHomeInactive,
                      width: 20,
                      height: 21,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () => context.goNamed(AppRoute.likes.name),
                    child: active == AppNavTab.likes
                        ? SvgPicture.asset(Assets.icons.navHeartActive, width: 28, height: 28)
                        : SvgPicture.asset(Assets.icons.navHeart, width: 24, height: 22),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: SvgPicture.asset(Assets.icons.navSend, width: 21, height: 21),
                ),
              ),
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () => context.goNamed(AppRoute.profile.name),
                    child: profileActive
                        ? Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(shape: BoxShape.circle, gradient: AppGradients.button),
                            child: ClipOval(
                              child: Assets.images.navAvatar.image(width: 24, height: 24, fit: BoxFit.cover),
                            ),
                          )
                        : ClipOval(
                            child: Assets.images.navAvatar.image(width: 28, height: 28, fit: BoxFit.cover),
                          ),
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
