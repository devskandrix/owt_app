import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/router/app_route.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/top_notice.dart';
import '../../../dashboard/domain/entities/club.dart';
import '../../../settings/presentation/widgets/log_out_dialog.dart';
import '../../../dashboard/presentation/widgets/venue.dart';
import '../cubit/search_cubit.dart';
import '../cubit/search_state.dart';
import '../widgets/search_input_field.dart';
import '../widgets/search_result_tile.dart';
import '../widgets/search_section_header.dart';

/// Search screen, reached by tapping the search field on the dashboard.
/// With the field empty it shows Recent searches (each removable, plus
/// "Clear All") above all clubs; as the user types, results come from
/// `GET /clubs/search`. Tapping a club opens its match-making screen and
/// saves it to Recent.
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SearchCubit>(),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.background,
      bottomNavigationBar: const AppBottomNav(),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const AppTopBar(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SearchInputField(
                controller: _controller,
                onChanged: context.read<SearchCubit>().queryChanged,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BlocConsumer<SearchCubit, SearchState>(
                listenWhen: (prev, curr) =>
                    curr.notice != null && curr.notice != prev.notice,
                listener: (context, state) =>
                    TopNotice.showError(context, state.notice!),
                builder: (context, state) => _SearchBody(state: state),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBody extends StatelessWidget {
  const _SearchBody({required this.state});

  final SearchState state;

  void _open(BuildContext context, Club club, {String? query}) {
    context.read<SearchCubit>().openedClub(club, query: query);
    context.pushNamed(AppRoute.match.name, extra: Venue.fromClub(club).club);
  }

  Future<void> _confirmClearAll(BuildContext context) async {
    final cubit = context.read<SearchCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const LogOutDialog(
        title: AppStrings.searchClearConfirmTitle,
        message: AppStrings.searchClearConfirmMessage,
        confirmLabel: AppStrings.searchClearAll,
      ),
    );
    if (confirmed == true) cubit.clearHistory();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();
    final showRecent = state.query.isEmpty && state.history.isNotEmpty;

    // Results area: an error, a spinner, an empty message, or the list.
    final Widget? resultsStatus;
    if (state.status == SearchStatus.failure) {
      resultsStatus = _Message(
        text: state.errorMessage ?? AppStrings.somethingWentWrong,
        onRetry: cubit.retry,
      );
    } else if (state.status == SearchStatus.loading && state.results.isEmpty) {
      resultsStatus = const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (state.results.isEmpty) {
      resultsStatus = const _Message(text: AppStrings.searchNoResults);
    } else {
      resultsStatus = null;
    }

    // Without Recent, a status message fills the screen as before.
    if (!showRecent && resultsStatus != null) return resultsStatus;

    final showFooter = state.hasMore || state.isLoadingMore;
    final items = <Widget>[
      if (showRecent) ...[
        SearchSectionHeader(
          title: AppStrings.searchRecentTitle,
          actionLabel: AppStrings.searchClearAll,
          onAction: () => _confirmClearAll(context),
        ),
        for (final item in state.history)
          _ClubRow(
            key: ValueKey('recent-${item.id}'),
            club: item.club,
            query: '',
            onTap: () => _open(context, item.club, query: item.query),
            trailing: IconButton(
              tooltip: AppStrings.searchRemoveRecent,
              onPressed: () => cubit.removeHistory(item.id),
              icon: Icon(
                Icons.close_rounded,
                size: 20,
                color: context.appColors.textMuted,
              ),
            ),
          ),
        const SizedBox(height: 8),
        const SearchSectionHeader(title: AppStrings.searchAllClubsTitle),
      ],
      ?resultsStatus,
      if (resultsStatus == null) ...[
        for (final club in state.results)
          _ClubRow(
            key: ValueKey('result-${club.id}'),
            club: club,
            query: state.query,
            onTap: () => _open(context, club, query: state.query),
          ),
        if (showFooter)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
      ],
    ];

    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (n.metrics.extentAfter < 300) cubit.loadMore();
        return false;
      },
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) => items[index],
      ),
    );
  }
}

/// A tappable club row: a [SearchResultTile] with an optional [trailing].
class _ClubRow extends StatelessWidget {
  const _ClubRow({
    super.key,
    required this.club,
    required this.query,
    required this.onTap,
    this.trailing,
  });

  final Club club;
  final String query;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SearchResultTile(
        venue: Venue.fromClub(club),
        query: query,
        trailing: trailing,
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, this.onRetry});

  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: AppTextStyles.authSubtitle.copyWith(
              fontSize: 14,
              color: colors.textMuted,
            ),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: Text(
                AppStrings.retryLabel,
                style: AppTextStyles.viewAll.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
