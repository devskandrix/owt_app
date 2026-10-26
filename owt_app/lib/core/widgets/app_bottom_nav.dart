import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../gen/assets.gen.dart';
import '../di/injection_container.dart';
import '../router/app_route.dart';
import '../theme/app_gradients.dart';

/// The tab highlighted in [AppBottomNav].
enum AppNavTab { home, likes, messages, profile }

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

  static const Color _dockColor = Color(0xFF17181A);

  @override
  Widget build(BuildContext context) {
    final profileActive = active == AppNavTab.profile;
    // With a home indicator / gesture bar, SafeArea adds the inset below
    // and 6px is enough; with Android's 3-button bar there's no inset, so
    // pad the bottom to match the top instead of crowding the icons.
    final hasBottomInset = MediaQuery.viewPaddingOf(context).bottom > 0;
    // Paints Android's system navigation bar the same color as the dock
    // (no effect on iOS).
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: _dockColor,
        systemNavigationBarDividerColor: _dockColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: _dockColor,
          border: Border(top: BorderSide(color: _dockColor)),
        ),
        padding: EdgeInsets.fromLTRB(16, 16, 16, hasBottomInset ? 6 : 16),
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
                        active == AppNavTab.home
                            ? Assets.icons.navHome
                            : Assets.icons.navHomeInactive,
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
                          ? SvgPicture.asset(
                              Assets.icons.navHeartActive,
                              width: 28,
                              height: 28,
                            )
                          : SvgPicture.asset(
                              Assets.icons.navHeart,
                              width: 24,
                              height: 22,
                            ),
                    ),
                  ),
                ),
                Expanded(
                  // The whole slot is tappable; the bar is only 28px tall,
                  // so padding the icon itself would shrink it.
                  child: GestureDetector(
                    onTap: () => context.goNamed(AppRoute.messages.name),
                    behavior: HitTestBehavior.opaque,
                    child: Center(
                      child: SvgPicture.asset(
                        Assets.icons.navSend,
                        width: 21,
                        height: 21,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: () => context.goNamed(AppRoute.profile.name),
                      child: profileActive
                          ? Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: AppGradients.button,
                              ),
                              child: const _NavAvatar(size: 24),
                            )
                          : const _NavAvatar(size: 28),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The signed-in user's primary photo (from the shared [ProfileCubit]),
/// or the default avatar until it loads or if it fails.
class _NavAvatar extends StatefulWidget {
  const _NavAvatar({required this.size});

  final double size;

  @override
  State<_NavAvatar> createState() => _NavAvatarState();
}

class _NavAvatarState extends State<_NavAvatar> {
  final ProfileCubit _cubit = sl<ProfileCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.ensureLoaded();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    final fallback = Assets.images.navAvatar.image(
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
    return ClipOval(
      child: BlocBuilder<ProfileCubit, ProfileState>(
        bloc: _cubit,
        buildWhen: (previous, current) =>
            previous.profile?.avatarUrl != current.profile?.avatarUrl,
        builder: (context, state) {
          final url = state.profile?.avatarUrl;
          if (url == null) return fallback;
          return Image.network(
            url,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => fallback,
          );
        },
      ),
    );
  }
}
