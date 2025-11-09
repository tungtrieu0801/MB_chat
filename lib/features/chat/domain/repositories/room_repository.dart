import 'package:mobile_trip_togethor/features/chat/domain/entities/room.dart';

abstract class RoomRepository {

  Future<List<Room>> getListRoom();
}
