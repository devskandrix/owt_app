import 'chat_message.dart';

/// A live update from the chat socket.
sealed class ChatEvent {
  const ChatEvent();
}

/// `message:new`: a message in any of the user's chats (theirs or the
/// user's own, e.g. sent from another device).
class ChatMessageReceived extends ChatEvent {
  const ChatMessageReceived(this.message);

  final ChatMessage message;
}

/// `message:delivered`: the user's messages reached the other person.
/// [messageIds] empty means every sent message in [matchId] up to [at].
class ChatMessagesDelivered extends ChatEvent {
  const ChatMessagesDelivered({
    required this.at,
    this.matchId,
    this.messageIds = const {},
  });

  final String? matchId;
  final Set<String> messageIds;
  final DateTime at;
}

/// `message:read`: [readerId] read [matchId] up to [at].
///
/// The server also sends this to the reader's own other devices, so
/// [byMe] tells the user reading (on another device) apart from the other
/// person reading the user's messages.
class ChatMessagesRead extends ChatEvent {
  const ChatMessagesRead({
    required this.matchId,
    required this.at,
    this.readerId,
    this.byMe = false,
    this.messageIds = const {},
  });

  final String matchId;
  final String? readerId;
  final bool byMe;
  final Set<String> messageIds;
  final DateTime at;
}

/// `typing:update`: [userId] started or stopped typing in [matchId].
class ChatTypingChanged extends ChatEvent {
  const ChatTypingChanged({
    required this.matchId,
    required this.userId,
    required this.typing,
  });

  final String matchId;
  final String userId;
  final bool typing;
}
