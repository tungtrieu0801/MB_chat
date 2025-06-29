import 'package:equatable/equatable.dart';
import '../../../domain/entities/chat_message.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

// Trạng thái ban đầu
class ChatInitial extends ChatState {}

// Đang tải dữ liệu
class ChatLoading extends ChatState {}

// Tải thành công danh sách tin nhắn
class ChatLoaded extends ChatState {
  final List<ChatMessage> messages;

  const ChatLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

// Gửi tin nhắn thành công (nếu bạn cần xử lý riêng)
class MessageSent extends ChatState {}

// Có lỗi xảy ra
class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}
