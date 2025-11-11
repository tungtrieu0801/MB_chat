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