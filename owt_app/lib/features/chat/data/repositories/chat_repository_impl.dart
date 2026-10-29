import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/services/chat_socket_service.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../../domain/entities/chat_conversation.dart';
import '../../domain/entities/chat_event.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../models/chat_parsers.dart';

/// Calls [Dio] directly rather than through retrofit: chat payloads aren't
/// documented yet, so [ChatParsers] reads them leniently.
class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl(this.dio, this.profileCubit);

  final Dio dio;
  final ProfileCubit profileCubit;

  @override
  Future<String> myUserId() async {
    await profileCubit.ensureLoaded();
    final id = profileCubit.state.profile?.id;
    if (id == null) {
      throw const UnexpectedFailure('Couldn’t load your profile.');
    }
    return id;
  }

  @override
  Future<List<ChatConversation>> getConversations() async {
    final me = await myUserId();
    final data = await _request(
      'GET',
      '/chats',
      fallback: 'Failed to load your chats.',
    );
    return [
      for (final json in ChatParsers.list(data, const [
        'chats',
        'conversations',
        'items',
      ]))
        ?ChatParsers.conversation(json, myUserId: me),
    ];
  }

  @override
  Future<List<ChatMessage>> getMessages(
    String matchId, {
    int limit = 50,
    DateTime? before,
  }) async {
    final me = await myUserId();
    final data = await _request(
      'GET',
      '/chats/$matchId/messages',
      query: {
        'limit': limit,
        if (before != null) 'before': before.toUtc().toIso8601String(),
      },
      fallback: 'Failed to load messages.',
    );
    final messages = [
      for (final json in ChatParsers.list(data, const ['messages', 'items']))
        ?ChatParsers.message(json, myUserId: me, matchId: matchId),
    ];
    // The order isn't documented; screens expect oldest first.
    messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return messages;
  }

  @override
  Future<ChatMessage> sendText(String matchId, String content) async {
    final me = await myUserId();
    final data = await _request(
      'POST',
      '/chats/$matchId/messages',
      body: {'content': content},
      fallback: 'Message not sent.',
    );
    return _sentMessage(data, me, matchId);
  }

  @override
  Future<ChatMessage> sendMedia(
    String matchId,
    File file, {
    String? caption,
    int? durationSeconds,
  }) async {
    final me = await myUserId();
    final name = file.path.split(Platform.pathSeparator).last;
    final form = FormData.fromMap({
      'media': await MultipartFile.fromFile(
        file.path,
        filename: name,
        contentType: _contentType(name),
      ),
      if (caption != null && caption.isNotEmpty) 'caption': caption,
      'duration': ?durationSeconds,
    });
    final data = await _request(
      'POST',
      '/chats/$matchId/messages/media',
      body: form,
      fallback: 'Couldn’t send this file.',
      // Uploads can take longer than the default 15s.
      timeout: const Duration(minutes: 2),
    );
    return _sentMessage(data, me, matchId);
  }

  @override
  Future<void> markRead(String matchId) async {
    if (ChatSocketService.emit(ChatSocketService.messageRead, {
      'matchId': matchId,
    })) {
      return;
    }
    await _request(
      'POST',
      '/chats/$matchId/read',
      fallback: 'Failed to mark the chat read.',
    );
  }

  @override
  void sendTyping(String matchId, {required bool typing}) {
    ChatSocketService.emit(
      typing ? ChatSocketService.typingStart : ChatSocketService.typingStop,
      {'matchId': matchId},
    );
  }

  @override
  Stream<void> get reconnects => ChatSocketService.reconnects;

  @override
  Stream<ChatEvent> get events =>
      ChatSocketService.events.asyncExpand((event) async* {
        final parsed = await _parseEvent(event);
        if (parsed != null) yield parsed;
      });

  Future<ChatEvent?> _parseEvent(ChatSocketEvent event) async {
    var data = event.data;
    // Socket.IO may deliver a single payload wrapped in a list.
    if (data is List && data.isNotEmpty) data = data.first;
    if (data is! Map) return null;
    final json = Map<String, dynamic>.from(data);
    final matchId = _string(json['matchId'] ?? json['chatId']);
    final at = _date(json['readAt'] ?? json['deliveredAt'] ?? json['at']);
    final ids = {
      ?_string(json['messageId']),
      for (final id in (json['messageIds'] as List?) ?? const []) ?_string(id),
    };

    switch (event.name) {
      case ChatSocketService.messageNew:
        final raw = json['message'] is Map
            ? Map<String, dynamic>.from(json['message'] as Map)
            : json;
        final message = ChatParsers.message(
          raw,
          myUserId: await myUserId(),
          matchId: matchId,
        );
        return message == null ? null : ChatMessageReceived(message);
      case ChatSocketService.messageDelivered:
        return ChatMessagesDelivered(
          matchId: matchId,
          messageIds: ids,
          at: at ?? DateTime.now(),
        );
      case ChatSocketService.messageRead:
        if (matchId == null) return null;
        final readerId = _string(
          json['readerId'] ?? json['userId'] ?? json['readBy'],
        );
        return ChatMessagesRead(
          matchId: matchId,
          readerId: readerId,
          byMe: readerId != null && readerId == await myUserId(),
          messageIds: ids,
          at: at ?? DateTime.now(),
        );
      case ChatSocketService.typingUpdate:
        final userId = _string(json['userId'] ?? json['senderId']);
        if (matchId == null || userId == null) return null;
        final typing = json['isTyping'] ?? json['typing'] ?? json['status'];
        return ChatTypingChanged(
          matchId: matchId,
          userId: userId,
          typing: typing == true || typing == 'start' || typing == 'typing',
        );
    }
    return null;
  }

  ChatMessage _sentMessage(dynamic data, String me, String matchId) {
    final json = data is Map<String, dynamic>
        ? (data['message'] is Map<String, dynamic>
              ? data['message'] as Map<String, dynamic>
              : data)
        : null;
    final message = json == null
        ? null
        : ChatParsers.message(json, myUserId: me, matchId: matchId);
    if (message == null) throw const ServerFailure('Message not sent.');
    return message;
  }

  /// Sends a request and returns the envelope's `data` once `success`.
  Future<dynamic> _request(
    String method,
    String path, {
    required String fallback,
    Object? body,
    Map<String, dynamic>? query,
    Duration? timeout,
  }) async {
    final accessToken = await TokenStorage.readAccessToken();
    if (accessToken == null) {
      throw const UnexpectedFailure('Missing session. Please sign in again.');
    }
    try {
      final response = await dio.request<dynamic>(
        path,
        data: body,
        queryParameters: query,
        options: Options(
          method: method,
          headers: {'Authorization': 'Bearer $accessToken'},
          sendTimeout: timeout,
          receiveTimeout: timeout,
        ),
      );
      final envelope = response.data;
      if (envelope is! Map<String, dynamic> || envelope['success'] != true) {
        final message = envelope is Map<String, dynamic>
            ? envelope['message']
            : null;
        throw ServerFailure(message is String ? message : fallback);
      }
      return envelope['data'];
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map<String, dynamic> ? data['message'] : null;
      if (e.type == DioExceptionType.badResponse) {
        throw ServerFailure(
          message is String ? message : fallback,
          statusCode: e.response?.statusCode,
        );
      }
      throw NetworkFailure(
        'Could not reach the server. Check your connection and try again.',
      );
    }
  }

  static MediaType? _contentType(String name) {
    final ext = name.contains('.') ? name.split('.').last.toLowerCase() : '';
    return switch (ext) {
      'jpg' || 'jpeg' => MediaType('image', 'jpeg'),
      'png' => MediaType('image', 'png'),
      'webp' => MediaType('image', 'webp'),
      'gif' => MediaType('image', 'gif'),
      'heic' => MediaType('image', 'heic'),
      'mp4' => MediaType('video', 'mp4'),
      'mov' => MediaType('video', 'quicktime'),
      'm4a' => MediaType('audio', 'mp4'),
      'aac' => MediaType('audio', 'aac'),
      'mp3' => MediaType('audio', 'mpeg'),
      'wav' => MediaType('audio', 'wav'),
      _ => null,
    };
  }

  static String? _string(dynamic value) {
    if (value is num) return value.toString();
    return value is String && value.isNotEmpty ? value : null;
  }

  static DateTime? _date(dynamic value) =>
      value is String ? DateTime.tryParse(value)?.toLocal() : null;
}
