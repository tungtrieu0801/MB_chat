import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

// Sự kiện load toàn bộ tin nhắn của 1 room
class LoadChat extends ChatEvent {
  final String roomId;

  const LoadChat(this.roomId);

  @override
  List<Object?> get props => [roomId];
}

// Sự kiện gửi một tin nhắn
class SendMessage extends ChatEvent {
  final String roomId;
  final String content;

  const SendMessage({required this.roomId, required this.content});

  @override
  List<Object?> get props => [roomId, content];
}
