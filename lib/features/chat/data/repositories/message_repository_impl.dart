import 'package:mobile_trip_togethor/features/chat/data/datasource/message_remote_datasource.dart';
import 'package:mobile_trip_togethor/features/chat/domain/entities/message.dart';
import 'package:mobile_trip_togethor/features/chat/domain/repositories/message_repository.dart';

import '../../domain/entities/reaction.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageRemoteDataSource remoteDataSource;

  MessageRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Message>> getListMessageInRoom(String roomId) async {
    try {
      final listMessageModel = await remoteDataSource.getListMessage(roomId);

      final listMessageInRoom = listMessageModel.map((model) {
        return Message(
          id: model.id,
          roomId: model.roomId,
          senderId: model.senderId,
          content: model.content,
          type: model.type,
          mentionedUserIds: model.mentionedUserIds,
          isPinned: model.isPinned,
          isEdited: model.isEdited,
          isDeleted: model.isDeleted,
          // reactions: model.reactions.map((r) => Reaction(
          //   userId: r.userId,
          //   emoji: r.emoji,
          // )).toList(),
          reactions: model.reactions,
          createdAt: model.createdAt,
          updatedAt: model.updatedAt,
        );
      }).toList();
      return listMessageInRoom;
    } catch (e) {
      rethrow;
    }
  }

}