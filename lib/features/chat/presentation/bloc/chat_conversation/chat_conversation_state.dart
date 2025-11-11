import 'package:equatable/equatable.dart';
import 'package:mobile_trip_togethor/features/chat/domain/entities/message.dart';

abstract class ChatConversationState extends Equatable {
  const ChatConversationState();

  @override
  List<Object?> get props => [];
}

class ChatConversationInitial extends ChatConversationState {}

class ChatConversationLoading extends ChatConversationState {}

class ChatConversationLoaded extends ChatConversationState {
  final List<Message> messages;

  const ChatConversationLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatConversationError extends ChatConversationState {
  final String message;

  const ChatConversationError(this.message);

  @override
  List<Object?> get props => [message];
}
