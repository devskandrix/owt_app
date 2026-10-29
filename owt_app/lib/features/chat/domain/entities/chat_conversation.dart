import 'package:equatable/equatable.dart';

import 'chat_message.dart';

/// One row of the inbox (`GET /chats`): the match, who it's with, and the
/// latest message.
class ChatConversation extends Equatable {
  final String matchId;
  final String userId;
  final String name;
  final String? avatarUrl;
  final ChatMessage? lastMessage;
  final int unreadCount;

  const ChatConversation({
    required this.matchId,
    required this.userId,
    required this.name,
    this.avatarUrl,
    this.lastMessage,
    this.unreadCount = 0,
  });

  /// For sorting: the latest message's time.
  DateTime? get lastActivity => lastMessage?.createdAt;

  ChatConversation copyWith({ChatMessage? lastMessage, int? unreadCount}) =>
      ChatConversation(
        matchId: matchId,
        userId: userId,
        name: name,
        avatarUrl: avatarUrl,
        lastMessage: lastMessage ?? this.lastMessage,
        unreadCount: unreadCount ?? this.unreadCount,
      );

  @override
  List<Object?> get props => [
    matchId,
    userId,
    name,
    avatarUrl,
    lastMessage,
    unreadCount,
  ];
}
