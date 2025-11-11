import 'reaction.dart';

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
  final List<Reaction> reactions;
  final DateTime createdAt;
  final DateTime updatedAt;

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
  });
}
