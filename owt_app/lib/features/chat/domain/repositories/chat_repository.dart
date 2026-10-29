import 'dart:io';

import '../entities/chat_conversation.dart';
import '../entities/chat_event.dart';
import '../entities/chat_message.dart';

/// Chat over our backend: REST for the inbox, history and sending, and the
/// Socket.IO connection for live updates.
abstract class ChatRepository {
  /// The signed-in user's id (loads the profile if needed).
  Future<String> myUserId();

  /// The inbox (`GET /chats`).
  Future<List<ChatConversation>> getConversations();

  /// Up to [limit] messages older than [before] (newest if null), oldest
  /// first (`GET /chats/:matchId/messages`).
  Future<List<ChatMessage>> getMessages(
    String matchId, {
    int limit = 50,
    DateTime? before,
  });

  /// `POST /chats/:matchId/messages`.
  Future<ChatMessage> sendText(String matchId, String content);

  /// `POST /chats/:matchId/messages/media` (photo, video or voice note).
  Future<ChatMessage> sendMedia(
    String matchId,
    File file, {
    String? caption,
    int? durationSeconds,
  });

  /// Marks the chat read: over the socket when connected, otherwise
  /// `POST /chats/:matchId/read`.
  Future<void> markRead(String matchId);

  /// `typing:start` / `typing:stop` for [matchId].
  void sendTyping(String matchId, {required bool typing});

  /// Live chat events, already parsed.
  Stream<ChatEvent> get events;

  /// Fires when the socket (re)connects, so screens can catch up.
  Stream<void> get reconnects;
}
