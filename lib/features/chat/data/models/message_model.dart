import 'dart:convert';

import 'package:mobile_trip_togethor/features/chat/data/models/user_chat_model.dart';
import 'package:mobile_trip_togethor/features/chat/domain/entities/user_chat.dart';

import '../../domain/entities/message.dart';
import 'reaction_model.dart';

class MessageModel {
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
  final UserChatModel user;

  MessageModel({
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
    required this.user,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      roomId: json['roomId'],
      senderId: json['senderId'],
      content: json['content'],
      type: json['type'] ?? 'text',
      mentionedUserIds: List<String>.from(json['mentionedUserIds'] ?? []),
      isPinned: json['isPinned'] ?? false,
      isEdited: json['isEdited'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      reactions: List<String>.from(json['reaction'] ?? []),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: UserChatModel.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'senderId': senderId,
      'content': content,
      'type': type,
      'mentionedUserIds': mentionedUserIds,
      'isPinned': isPinned,
      'isEdited': isEdited,
      'isDeleted': isDeleted,
      'reactions': reactions,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Message toEntity() {
    return Message(
      id: id,
      roomId: roomId,
      senderId: senderId,
      content: content,
      type: type,
      mentionedUserIds: mentionedUserIds,
      isPinned: isPinned,
      isEdited: isEdited,
      isDeleted: isDeleted,
      reactions: reactions,
      createdAt: createdAt,
      updatedAt: updatedAt,
      status: MessageStatus.sent,
      userChat: UserChat(
        id: user.id,
        fullname: user.fullname,
        avatar: user.avatar,
      ),
    );
  }
}
