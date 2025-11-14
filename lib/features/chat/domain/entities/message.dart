import 'reaction.dart';

enum MessageStatus { sending, sent, received }

class Message {
  final String id;
  final String roomId;
  final String senderId;
  final String content;
  final String type;
  final List mentionedUserIds;
  final bool isPinned;
  final bool isEdited;
  final bool isDeleted;
  final List reactions;
  final DateTime createdAt;
  final DateTime updatedAt;
  MessageStatus status;

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
  });
}
// --- Extension copyWith ---
extension MessageCopy on Message {
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
    );
  }
}