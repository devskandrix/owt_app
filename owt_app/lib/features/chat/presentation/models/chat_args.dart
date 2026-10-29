import 'package:equatable/equatable.dart';

import '../../../../core/services/zego_service.dart';

/// Who a 1-to-1 chat is with; passed as the chat route's `extra`.
/// [matchId] keys the chat on our backend; [userId] is the other person's
/// backend id, and [zegoId] their ZEGOCLOUD id (who to call).
class ChatArgs extends Equatable {
  final String matchId;
  final String userId;
  final String name;
  final String? avatarUrl;

  const ChatArgs({
    required this.matchId,
    required this.userId,
    required this.name,
    this.avatarUrl,
  });

  String get zegoId => ZegoService.idFor(userId);

  @override
  List<Object?> get props => [matchId, userId, name, avatarUrl];
}
