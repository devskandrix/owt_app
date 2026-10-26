import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/router/app_route.dart';
import '../../../../core/services/zego_service.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/widgets/app_bottom_nav.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../friends/domain/entities/friend.dart';
import '../../../friends/domain/usecases/get_friends.dart';
import '../models/chat_args.dart';
import '../widgets/chat_unavailable.dart';
import '../widgets/conversation_tile.dart';
import '../widgets/messages_header.dart';

/// "Messages": the user's 1-to-1 chats (ZEGOCLOUD ZIMKit), opened from the
/// bottom nav. Only current matches (`GET /matches`) are shown, so
/// unmatched people disappear from the list. Only chats that have started
/// are listed; a new chat is started from Friends or a friend's profile.
class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  late final Future<_ChatData> _data = _load();

  Future<_ChatData> _load() async {
    await ZegoService.login();
    // ZIMKit queries ZEGOCLOUD straight away, so only touch it once signed
    // in (the error state below covers a failed sign-in).
    if (!ZegoService.isLoggedIn) throw StateError('Chat sign-in failed');
    final friends = sl<GetFriends>()(const NoParams());
    final conversations = ZIMKit().getConversationListNotifier();
    return _ChatData(await friends, await conversations);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: !ZegoService.isAvailable
                  ? const ChatUnavailable()
                  : FutureBuilder<_ChatData>(
                      future: _data,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final data = snapshot.data;
                        if (snapshot.hasError || data == null) {
                          return const ChatUnavailable(
                            message: AppStrings.somethingWentWrong,
                          );
                        }
                        return _ConversationList(data: data);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatData {
  const _ChatData(this.friends, this.conversations);

  final List<Friend> friends;
  final ZIMKitConversationListNotifier conversations;
}

class _ConversationList extends StatelessWidget {
  const _ConversationList({required this.data});

  final _ChatData data;

  void _open(BuildContext context, Friend friend) {
    context.pushNamed(
      AppRoute.chat.name,
      extra: ChatArgs(
        userId: friend.userId,
        name: friend.name,
        avatarUrl: friend.avatarUrl,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Conversations are keyed by ZEGOCLOUD id, not our backend id.
    final friendsById = {
      for (final f in data.friends) ZegoService.idFor(f.userId): f,
    };
    return ValueListenableBuilder<List<ZIMKitConversationNotifier>>(
      valueListenable: data.conversations,
      builder: (context, conversations, _) {
        final chats = [
          for (final c in conversations)
            if (friendsById.containsKey(c.value.id) &&
                c.value.lastMessage != null)
              c,
        ];

        if (chats.isEmpty) {
          return const ChatUnavailable(message: AppStrings.messagesEmpty);
        }

        return NotificationListener<ScrollEndNotification>(
          onNotification: (notification) {
            final metrics = notification.metrics;
            if (metrics.pixels >= metrics.maxScrollExtent - 200) {
              ZIMKit().loadMoreConversation();
            }
            return false;
          },
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 12),
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final notifier = chats[index];
              final friend = friendsById[notifier.value.id]!;
              // Each conversation updates on its own (new message, unread
              // count), so listen to it per row.
              return ValueListenableBuilder<ZIMKitConversation>(
                valueListenable: notifier,
                builder: (context, conversation, _) {
                  final lastMessage = conversation.lastMessage;
                  // Only started chats are listed; hide one that has since
                  // lost its messages (e.g. deleted).
                  if (lastMessage == null) return const SizedBox.shrink();
                  return ConversationTile(
                    name: friend.name,
                    avatarUrl: friend.avatarUrl ?? conversation.avatarUrl,
                    conversation: conversation,
                    lastMessage: lastMessage,
                    onTap: () => _open(context, friend),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
