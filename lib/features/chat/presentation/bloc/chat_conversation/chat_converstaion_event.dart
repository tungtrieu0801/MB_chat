import 'package:equatable/equatable.dart';

abstract class ChatConversationEvent extends Equatable {
  const ChatConversationEvent();

  @override
  List<Object?> get props => [];
}

class GetListMessageEvent extends ChatConversationEvent {
  final String roomId;
  const GetListMessageEvent(this.roomId);

  @override
  List<Object?> get props => [roomId];
}

class SendMessageEvent extends ChatConversationEvent {
  final String roomId;
  final String content;
  const SendMessageEvent({required this.roomId, required this.content});

  @override
  List<Object?> get props => [roomId, content];
}

class ReceiveMessageEvent extends ChatConversationEvent {
  final Map<String, dynamic> message;
  const ReceiveMessageEvent(this.message);

  @override
  List<Object?> get props => [message];
}

class JoinRoomEvent extends ChatConversationEvent {
  final String roomId;
  const JoinRoomEvent(this.roomId);

  @override
  List<Object?> get props => [roomId];
}

class UserTypingEvent extends ChatConversationEvent {
  final String userId;
  final bool isTyping;
  const UserTypingEvent(this.userId, this.isTyping);

  @override
  List<Object?> get props => [userId, isTyping];
}

// ---------------- Reaction ----------------
class ReactMessageEvent extends ChatConversationEvent {
  final String roomId;
  final String messageId;
  final String reaction;
  final bool fromServer;
  const ReactMessageEvent({
    required this.roomId,
    required this.messageId,
    required this.reaction,
    this.fromServer = false, // <-- mới
  });

  @override
  List<Object?> get props => [roomId, messageId, reaction];
}

class ReceiveMessageReactedEvent extends ChatConversationEvent {
  final Map<String, dynamic> data;
  const ReceiveMessageReactedEvent(this.data);

  @override
  List<Object?> get props => [data];
}
