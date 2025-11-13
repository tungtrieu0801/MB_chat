import 'package:mobile_trip_togethor/features/chat/data/datasource/room_remote_datasource.dart';
import 'package:mobile_trip_togethor/features/chat/domain/entities/room.dart';
import 'package:mobile_trip_togethor/features/chat/domain/repositories/room_repository.dart';

class RoomRepositoryImpl implements RoomRepository {
  final RoomRemoteDatasource remoteDatasource;

  RoomRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<Room>> getListRoom() async {
    try {
      final listRoomModel = await remoteDatasource.getListRoom();

      final listRoom = listRoomModel.map((model) {
        return Room(
          id: model.id,
          roomSingleId: model.roomSingleId,
          name: model.name,
          description: model.description,
          isGroup: model.isGroup,
          memberIds: model.memberIds,
          lastMessage: model.lastMessage,
          lastMessageAt: model.lastMessageAt,
          createdBy: model.createdBy,
          avatar: model.avatar,
          pinnedBy: model.pinnedBy,
          unreadCounts: model.unreadCounts,
          status: model.status,
          lastOnlineAt: model.lastOnlineAt,
        );
      }).toList();

      return listRoom;
    } catch (e) {
      rethrow;
    }
  }
}
