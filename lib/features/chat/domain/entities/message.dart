import 'package:mobile_trip_togethor/features/chat/domain/entities/user_chat.dart';

import 'reaction.dart';

enum MessageStatus { sending, sent, received }

class Message {
  final String id;
  final String roomId;
  final String senderId;
  final String content;
  final String type;
  final List<String> mentionedUserIds;
  final bool isPinned;
  final bool isEdited;
  final bool isDeleted;
  final List<String> reactions;
  final DateTime createdAt;
  final DateTime updatedAt;
  MessageStatus status;
  UserChat userChat;

  Message({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.content,
    required this.type,
    required this.mentionedUserIds,
    required this.isPinned,
    required this.isEdited,
    required this.isDeleted,
    required this.reactions,
    required this.createdAt,
    required this.updatedAt,
    this.status = MessageStatus.sending,
    required this.userChat,
  });

  // --- Factory from JSON ---
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      roomId: json['roomId'],
      senderId: json['senderId'],
      content: json['content'],
      type: json['type'],
      mentionedUserIds: List<String>.from(json['mentionedUserIds'] ?? []),
      isPinned: json['isPinned'] ?? false,
      isEdited: json['isEdited'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      reactions: List<String>.from(json['reactions'] ?? []),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      status: MessageStatus.sent,
      userChat: UserChat(
        id: json['user']['_id'].toString(),
        fullname: json['user']['fullname'].toString(),
        avatar: json['user']['avatar'].toString(),
      ),
    );
  }

  // --- Extension copyWith ---
  Message copyWith({
    List<String>? reactions,
    MessageStatus? status,
    String? content,
    DateTime? updatedAt,
  }) {
    return Message(
      id: id,
      roomId: roomId,
      senderId: senderId,
      content: content ?? this.content,
      type: type,
      mentionedUserIds: mentionedUserIds,
      isPinned: isPinned,
      isEdited: isEdited,
      isDeleted: isDeleted,
      reactions: reactions ?? this.reactions,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      userChat: userChat,
    );
  }
}
