import 'package:equatable/equatable.dart';

import '../../../../core/services/zego_service.dart';

/// Who a 1-to-1 chat is with; passed as the chat route's `extra`. [userId]
/// is our backend user id; [zegoId] is theirs on ZEGOCLOUD (the chat's
/// conversation id, and who to call).
class ChatArgs extends Equatable {
  final String userId;
  final String name;
  final String? avatarUrl;

  const ChatArgs({required this.userId, required this.name, this.avatarUrl});

  String get zegoId => ZegoService.idFor(userId);

  @override
  List<Object?> get props => [userId, name, avatarUrl];
}
