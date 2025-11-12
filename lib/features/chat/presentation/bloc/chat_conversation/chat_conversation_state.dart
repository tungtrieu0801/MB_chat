import 'package:equatable/equatable.dart';
enum MessageStatus { sending, sent, received }
class Message {
  final String id;
  final String content;
  final String roomId;
  final String senderId;
  final DateTime createdAt;
  MessageStatus status;

  Message({
    required this.id,
    required this.content,
    required this.roomId,
    required this.senderId,
    required this.createdAt,
    this.status = MessageStatus.sending,
  });
}

abstract class ChatConversationState extends Equatable {
  const ChatConversationState();

  @override
  List<Object?> get props => [];
}

class ChatConversationInitial extends ChatConversationState {}

class ChatConversationLoading extends ChatConversationState {}

class ChatConversationLoaded extends ChatConversationState {
  final List<Message> messages;
  final String? currentUserId;

  const ChatConversationLoaded(this.messages, this.currentUserId);

  @override
  List<Object?> get props => [messages];
}

class ChatConversationError extends ChatConversationState {
  final String message;

  const ChatConversationError(this.message);

  @override
  List<Object?> get props => [message];
}
