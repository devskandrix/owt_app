import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_route.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../gen/assets.gen.dart';
import '../cubit/likes_cubit.dart';
import '../cubit/likes_state.dart';
import '../widgets/liked_user_tile.dart';
import '../widgets/liked_you_card.dart';
import '../widgets/match_banner.dart';

/// "Likes" tab: a "Liked You" summary, then everyone who liked the user,
/// each with Confirm (turns the row into an "It’s Match" banner) and X.
/// Theme-aware like the app's other non-photo screens; Figma only shows
/// the dark version.
class LikesPage extends StatelessWidget {
  const LikesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => LikesCubit(), child: const _LikesView());
  }
}

class _LikesView extends StatelessWidget {
  const _LikesView();

  // Sample avatars until likes come from the API (see LikesCubit).
  static final List<AssetGenImage> _previewAvatars = [
    Assets.images.likesAvatar1,
    Assets.images.likesAvatar2,
    Assets.images.likesAvatar3,
  ];
  static final List<AssetGenImage> _rowAvatars = [
    Assets.images.likesAvatar4,
    Assets.images.likesAvatar1,
    Assets.images.likesAvatar2,
    Assets.images.likesAvatar3,
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.background,
      bottomNavigationBar: const AppBottomNav(active: AppNavTab.likes),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<LikesCubit, LikesState>(
          builder: (context, state) {
            final cubit = context.read<LikesCubit>();
            final hidden = state.totalLikes - _previewAvatars.length;
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _Header(colors: colors)),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 35),
                  sliver: SliverToBoxAdapter(
                    child: LikedYouCard(
                      previews: _previewAvatars,
                      extra: hidden > 0 ? hidden : 0,
                    ),
                  ),
                ),
                if (state.likes.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        AppStrings.likesEmpty,
                        style: AppTextStyles.likesName.copyWith(
                          color: colors.textMuted,
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    sliver: SliverList.separated(
                      itemCount: state.likes.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 22),
                      itemBuilder: (context, index) {
                        final user = state.likes[index];
                        if (state.matchedIds.contains(user.id)) {
                          return MatchBanner(
                            onDismiss: () => cubit.remove(user.id),
                          );
                        }
                        return LikedUserTile(
                          user: user,
                          avatar: _rowAvatars[index % _rowAvatars.length],
                          onConfirm: () => cubit.confirm(user.id),
                          onDismiss: () => cubit.remove(user.id),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// "Likes" title (centered in the space left of the bell, per Figma) and
/// the notifications bell.
class _Header extends StatelessWidget {
  const _Header({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: Text(
                AppStrings.likesTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.likesName.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => context.pushNamed(AppRoute.notifications.name),
              child: SvgPicture.asset(
                Assets.icons.bell,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  colors.textPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
