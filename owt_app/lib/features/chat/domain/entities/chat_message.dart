import 'package:equatable/equatable.dart';

enum ChatMessageType { text, image, video, audio, unknown }

/// Where an outgoing message is in sending. Messages from the server are
/// always [sent].
enum ChatSendState { sending, sent, failed }

/// Ticks under an outgoing message, from the server's timestamps.
enum ChatTicks { single, delivered, read }

/// One chat message (`GET /chats/:matchId/messages`, `message:new`).
///
/// Messages the user is still sending exist locally first (optimistic
/// UI): they carry a [localId], and for media the [localFilePath], until
/// the server's copy replaces them.
class ChatMessage extends Equatable {
  /// Server id; empty while still sending.
  final String id;
  final String matchId;
  final String senderId;
  final bool isMine;
  final ChatMessageType type;

  /// Text, or a media caption.
  final String? content;
  final String? mediaUrl;

  /// Voice note / video length in seconds.
  final int? durationSeconds;
  final DateTime createdAt;
  final DateTime? deliveredAt;
  final DateTime? readAt;

  /// Client-only id for a message being sent.
  final String? localId;
  final String? localFilePath;
  final ChatSendState sendState;

  const ChatMessage({
    required this.id,
    required this.matchId,
    required this.senderId,
    required this.isMine,
    required this.type,
    required this.createdAt,
    this.content,
    this.mediaUrl,
    this.durationSeconds,
    this.deliveredAt,
    this.readAt,
    this.localId,
    this.localFilePath,
    this.sendState = ChatSendState.sent,
  });

  /// Single tick until delivered, gray double tick once delivered, blue
  /// double tick once read.
  ChatTicks get ticks => readAt != null
      ? ChatTicks.read
      : deliveredAt != null
      ? ChatTicks.delivered
      : ChatTicks.single;

  /// A stable key for list rows: the server id once known.
  String get key => id.isNotEmpty ? id : (localId ?? '');

  ChatMessage copyWith({
    DateTime? deliveredAt,
    DateTime? readAt,
    ChatSendState? sendState,
  }) => ChatMessage(
    id: id,
    matchId: matchId,
    senderId: senderId,
    isMine: isMine,
    type: type,
    createdAt: createdAt,
    content: content,
    mediaUrl: mediaUrl,
    durationSeconds: durationSeconds,
    deliveredAt: deliveredAt ?? this.deliveredAt,
    readAt: readAt ?? this.readAt,
    localId: localId,
    localFilePath: localFilePath,
    sendState: sendState ?? this.sendState,
  );

  @override
  List<Object?> get props => [
    id,
    matchId,
    senderId,
    isMine,
    type,
    content,
    mediaUrl,
    durationSeconds,
    createdAt,
    deliveredAt,
    readAt,
    localId,
    localFilePath,
    sendState,
  ];
}
