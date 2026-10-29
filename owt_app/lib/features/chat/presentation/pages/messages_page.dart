import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/router/app_route.dart';
import '../../../../core/services/chat_socket_service.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../domain/entities/chat_conversation.dart';
import '../cubit/chat_list_cubit.dart';
import '../models/chat_args.dart';
import '../widgets/chat_unavailable.dart';
import '../widgets/conversation_tile.dart';
import '../widgets/messages_header.dart';

/// "Messages": the user's chats (`GET /chats`), opened from the bottom
/// nav and kept live over the chat socket. A new chat is started from
/// Friends or a friend's profile.
class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Normally already connected from Home.
    ChatSocketService.connect();
    return BlocProvider(
      create: (_) => ChatListCubit(sl()),
      child: Scaffold(
        backgroundColor: context.appColors.background,
        bottomNavigationBar: const AppBottomNav(active: AppNavTab.messages),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // No unread-count request here; the bell shows the count last
              // loaded on Home.
              const AppTopBar(refreshNotificationCount: false),
              const MessagesHeader(),
              Expanded(
                child: BlocBuilder<ChatListCubit, ChatListState>(
                  builder: (context, state) {
                    final cubit = context.read<ChatListCubit>();
                    switch (state.status) {
                      case ChatListStatus.loading:
                        return const Center(child: CircularProgressIndicator());
                      case ChatListStatus.failure:
                        return GestureDetector(
                          onTap: cubit.load,
                          child: ChatUnavailable(
                            message:
                                '${state.errorMessage ?? AppStrings.somethingWentWrong}\n'
                                '${AppStrings.retryLabel}',
                          ),
                        );
                      case ChatListStatus.loaded:
                        return RefreshIndicator(
                          onRefresh: () => cubit.load(silent: true),
                          child: state.conversations.isEmpty
                              ? ListView(
                                  children: const [
                                    SizedBox(height: 160),
                                    ChatUnavailable(
                                      message: AppStrings.messagesEmpty,
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  itemCount: state.conversations.length,
                                  itemBuilder: (context, index) {
                                    final c = state.conversations[index];
                                    return ConversationTile(
                                      key: ValueKey(c.matchId),
                                      conversation: c,
                                      onTap: () => _open(context, c),
                                    );
                                  },
                                ),
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _open(BuildContext context, ChatConversation c) async {
    final cubit = context.read<ChatListCubit>();
    cubit.opened(c.matchId);
    await context.pushNamed(
      AppRoute.chat.name,
      extra: ChatArgs(
        matchId: c.matchId,
        userId: c.userId,
        name: c.name,
        avatarUrl: c.avatarUrl,
      ),
    );
    // Pick up anything sent or read while the chat was open.
    cubit.load(silent: true);
  }
}
