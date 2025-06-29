import 'package:mobile_trip_togethor/features/chat/domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  final String id;
  final String content;
  final String senderId;

  ChatMessageModel({
    required this.id,
    required this.content,
    required this.senderId,
  }) : super(id: id, content: content, senderId: senderId);

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'],
      content: json['content'],
      senderId: json['sender_id'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'sender_id': senderId,
  };
}
