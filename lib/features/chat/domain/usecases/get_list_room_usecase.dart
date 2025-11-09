import 'package:mobile_trip_togethor/features/chat/domain/entities/room.dart';
import 'package:mobile_trip_togethor/features/chat/domain/repositories/room_repository.dart';

class GetListRoomUseCase {
  final RoomRepository repository;

  GetListRoomUseCase(this.repository);

  Future<List<Room>> getListRoom() {
    return repository.getListRoom();
  }

}
