import '../../../../core/network/media_url.dart';
import '../../../matchmaking/data/models/discover_profile_model.dart';
import '../../domain/entities/chat_conversation.dart';
import '../../domain/entities/chat_message.dart';

/// Parses chat payloads from REST and the socket. The exact field names
/// aren't documented, so common alternatives are accepted (e.g.
/// `content` / `text`, `type` / `messageType`).
abstract final class ChatParsers {
  /// A message, or null if it has no id. [myUserId] decides [isMine].
  static ChatMessage? message(
    Map<String, dynamic> json, {
    required String myUserId,
    String? matchId,
  }) {
    final id = _string(json['id'] ?? json['_id'] ?? json['messageId']);
    if (id == null) return null;
    final sender = _map(json['sender']);
    final senderId =
        _string(json['senderId'] ?? json['fromUserId'] ?? sender?['id']) ?? '';
    final mediaUrl = _string(
      json['mediaUrl'] ?? json['media'] ?? json['url'] ?? json['fileUrl'],
    );
    return ChatMessage(
      id: id,
      matchId: _string(json['matchId'] ?? json['chatId']) ?? matchId ?? '',
      senderId: senderId,
      isMine: senderId.isNotEmpty && senderId == myUserId,
      type: _type(json['type'] ?? json['messageType'], mediaUrl),
      content: _string(json['content'] ?? json['text'] ?? json['caption']),
      mediaUrl: mediaUrl == null ? null : resolveMediaUrl(mediaUrl),
      durationSeconds: _int(
        json['mediaDuration'] ?? json['duration'] ?? json['durationSeconds'],
      ),
      createdAt:
          _date(json['createdAt'] ?? json['sentAt'] ?? json['timestamp']) ??
          DateTime.now(),
      deliveredAt: _date(json['deliveredAt']),
      readAt: _date(json['readAt']),
    );
  }

  /// An inbox row, or null without a match id or other person.
  static ChatConversation? conversation(
    Map<String, dynamic> json, {
    required String myUserId,
  }) {
    final matchId = _string(json['matchId'] ?? json['id']);
    final user = _map(
      json['user'] ??
          json['otherUser'] ??
          json['matchedUser'] ??
          json['partner'] ??
          json['participant'],
    );
    if (matchId == null || user == null) return null;
    final profile = DiscoverProfileModel.fromJson({'user': user});
    final last = _map(json['lastMessage'] ?? json['latestMessage']);
    return ChatConversation(
      matchId: matchId,
      userId: profile.id,
      name: profile.fullName,
      avatarUrl: profile.photoUrls.isEmpty ? null : profile.photoUrls.first,
      lastMessage: last == null
          ? null
          : message(last, myUserId: myUserId, matchId: matchId),
      unreadCount: _int(json['unreadCount'] ?? json['unread']) ?? 0,
    );
  }

  /// The list inside a response's `data`: either the list itself or an
  /// object wrapping it.
  static List<Map<String, dynamic>> list(dynamic data, List<String> keys) {
    if (data is List) return data.whereType<Map<String, dynamic>>().toList();
    if (data is Map<String, dynamic>) {
      for (final key in keys) {
        final value = data[key];
        if (value is List) {
          return value.whereType<Map<String, dynamic>>().toList();
        }
      }
    }
    return const [];
  }

  static ChatMessageType _type(dynamic raw, String? mediaUrl) {
    final type = raw is String ? raw.toLowerCase() : '';
    if (type.contains('image') || type.contains('photo')) {
      return ChatMessageType.image;
    }
    if (type.contains('video')) return ChatMessageType.video;
    if (type.contains('audio') || type.contains('voice')) {
      return ChatMessageType.audio;
    }
    if (type.contains('text') || (type.isEmpty && mediaUrl == null)) {
      return ChatMessageType.text;
    }
    return ChatMessageType.unknown;
  }

  static Map<String, dynamic>? _map(dynamic value) =>
      value is Map<String, dynamic> ? value : null;

  static String? _string(dynamic value) {
    if (value is num) return value.toString();
    return value is String && value.trim().isNotEmpty ? value.trim() : null;
  }

  static int? _int(dynamic value) => value is num
      ? value.round()
      : value is String
      ? double.tryParse(value)?.round()
      : null;

  static DateTime? _date(dynamic value) {
    if (value is String) return DateTime.tryParse(value)?.toLocal();
    if (value is num) {
      return DateTime.fromMillisecondsSinceEpoch(value.toInt());
    }
    return null;
  }
}
