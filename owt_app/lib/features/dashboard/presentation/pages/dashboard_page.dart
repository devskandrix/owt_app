import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/router/app_route.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/services/push_notification_service.dart';
import '../../../../core/services/chat_socket_service.dart';
import '../../../../core/services/zego_service.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../going_tonight/presentation/widgets/going_tonight_location_dialog.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../widgets/dashboard_search_bar.dart';
import '../widgets/dashboard_section_header.dart';
import '../widgets/dashboard_status_view.dart';
import '../widgets/trending_carousel.dart';
import '../widgets/trending_empty_notice.dart';
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

class _DashboardView extends StatefulWidget {
  const _DashboardView();

  @override
  State<_DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<_DashboardView> {
  /// Ask at most once per app session — Home is rebuilt every time the
  /// user returns to it, and "Not Now" should stick until the next launch.
  static bool _askedForLocation = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _askForPermissions());
  }

  /// Location first, then notifications, so the two prompts never overlap.
  /// Home is the first signed-in screen for new and returning users alike.
  Future<void> _askForPermissions() async {
    // Chat (socket) and calls (ZEGOCLOUD) need no prompt, so start them
    // right away.
    ChatSocketService.connect();
    ZegoService.login();
    await _maybeAskForLocation();
    if (!mounted) return;
    await PushNotificationService.requestPermission();
  }

  /// Clubs load straight away without a location; if the user then allows
  /// it (our explainer, then the OS prompt), reload so `GET /clubs/home`
  /// gets latitude/longitude and "Near You" is sorted by distance. Skipped
  /// when the OS prompt can't appear (already allowed or already denied).
  Future<void> _maybeAskForLocation() async {
    if (_askedForLocation) return;
    final locationService = sl<LocationService>();
    if (!await locationService.canPromptForPermission() || !mounted) return;
    _askedForLocation = true;

    final allowed = await showDialog<bool>(
      context: context,
      builder: (_) => const GoingTonightLocationDialog(
        message: AppStrings.dashboardLocationMessage,
        confirmLabel: AppStrings.dashboardAllowLocation,
      ),
    );
    if (allowed != true) return;
    final access = await locationService.requestAccess();
    if (access == LocationAccess.granted && mounted) {
      context.read<DashboardCubit>().load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.background,
      bottomNavigationBar: const AppBottomNav(),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // The unread count arrives with `GET /clubs/home` (see
            // DashboardCubit), so the bell doesn't fetch it separately.
            const AppTopBar(refreshNotificationCount: false),
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
                            DashboardSectionHeader(
                              title: AppStrings.trendingSectionTitle,
                              showTrendingIcon: true,
                              showViewAll: false,
                            ),
                            const SizedBox(height: 12),
                            if (clubs.trending.isEmpty)
                              const TrendingEmptyNotice()
                            else
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
