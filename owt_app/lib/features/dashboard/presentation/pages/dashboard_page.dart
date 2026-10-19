import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/router/app_route.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../widgets/dashboard_search_bar.dart';
import '../widgets/dashboard_section_header.dart';
import '../widgets/dashboard_status_view.dart';
import '../widgets/trending_carousel.dart';
import '../widgets/venue.dart';
import '../widgets/venue_list_section.dart';

/// Home / dashboard screen. The scaffold background and page-level chrome
/// (header, search bar, section titles) adapt to theme; text and icons
/// drawn over venue photos stay white in both themes, since they sit on a
/// photo/dark scrim either way.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DashboardCubit>(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.background,
      bottomNavigationBar: const AppBottomNav(),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const AppTopBar(),
            // Search stays available whatever state the club lists are in,
            // so users can still find a club when the home feed fails.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: () => context.pushNamed(AppRoute.search.name),
                child: const DashboardSearchBar(),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<DashboardCubit, DashboardState>(
                builder: (context, state) {
                  if (state.loadStatus == DashboardLoadStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final cubit = context.read<DashboardCubit>();
                  final clubs = state.clubs;
                  return RefreshIndicator(
                    onRefresh: cubit.load,
                    child: switch (state.loadStatus) {
                      DashboardLoadStatus.failure => DashboardStatusView(
                        icon: Icons.wifi_off_rounded,
                        title: AppStrings.dashboardErrorTitle,
                        message:
                            state.errorMessage ?? AppStrings.somethingWentWrong,
                        onRetry: cubit.load,
                      ),
                      _ when clubs.isEmpty => DashboardStatusView(
                        icon: Icons.nightlife_rounded,
                        title: AppStrings.dashboardEmptyTitle,
                        message: AppStrings.dashboardEmptyMessage,
                        onRetry: cubit.load,
                      ),
                      _ => SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const DashboardSectionHeader(
                              title: AppStrings.trendingSectionTitle,
                              showTrendingIcon: true,
                            ),
                            const SizedBox(height: 12),
                            TrendingCarousel(
                              venues: clubs.trending
                                  .map(Venue.fromClub)
                                  .toList(),
                            ),
                            const SizedBox(height: 21),
                            VenueListSection(
                              title: AppStrings.topClubsSectionTitle,
                              venues: clubs.topClubs
                                  .map(Venue.fromClub)
                                  .toList(),
                            ),
                            const SizedBox(height: 24),
                            VenueListSection(
                              title: AppStrings.nearYouSectionTitle,
                              venues: clubs.nearYou
                                  .map(Venue.fromClub)
                                  .toList(),
                            ),
                            const SizedBox(height: 24),
                            VenueListSection(
                              title: AppStrings.recentlyViewSectionTitle,
                              venues: clubs.recentlyViewed
                                  .map(Venue.fromClub)
                                  .toList(),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
