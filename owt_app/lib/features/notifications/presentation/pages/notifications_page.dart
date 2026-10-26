import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/top_notice.dart';
import '../cubit/notifications_cubit.dart';
import '../widgets/notification_header.dart';
import '../widgets/notification_tile.dart';

/// "Notification" screen: the user's notifications from
/// `GET /notifications`, newest first, loading more on scroll. Tapping an
/// unread one marks it read. Pull down to refresh. Page-level chrome
/// (background, text) is theme-aware, matching the rest of the app's
/// non-photo screens.
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NotificationsCubit>()..load(),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            NotificationHeader(onBack: () => Navigator.of(context).maybePop()),
            Expanded(
              child: BlocConsumer<NotificationsCubit, NotificationsState>(
                // Errors with a list on screen show as a notice.
                listenWhen: (previous, current) =>
                    current.errorMessage != null &&
                    current.errorMessage != previous.errorMessage &&
                    current.status == NotificationsStatus.ready,
                listener: (context, state) =>
                    TopNotice.showError(context, state.errorMessage!),
                builder: (context, state) {
                  final cubit = context.read<NotificationsCubit>();
                  return switch (state.status) {
                    NotificationsStatus.loading => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    NotificationsStatus.failure => _Message(
                      text: state.errorMessage ?? AppStrings.somethingWentWrong,
                      onRetry: cubit.load,
                    ),
                    NotificationsStatus.ready => RefreshIndicator(
                      onRefresh: cubit.load,
                      child: state.items.isEmpty
                          ? CustomScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              slivers: [
                                SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: _Message(
                                    text: AppStrings.notificationsEmpty,
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              itemCount:
                                  state.items.length + (state.hasMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index >= state.items.length) {
                                  // Reaching the footer loads the next page.
                                  cubit.loadMore();
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Center(
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                final notification = state.items[index];
                                return NotificationTile(
                                  notification: notification,
                                  onTap: notification.isRead
                                      ? null
                                      : () => cubit.markRead(notification.id),
                                );
                              },
                            ),
                    ),
                  };
                },
              ),
            ),
          ],
        ),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: AppTextStyles.profileBio.copyWith(color: colors.textMuted),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: onRetry,
                child: const Text(AppStrings.retryLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
