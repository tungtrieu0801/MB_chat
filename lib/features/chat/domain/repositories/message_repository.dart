import 'package:mobile_trip_togethor/features/chat/domain/entities/message.dart';

abstract class MessageRepository {

  Future<List<Message>> getListMessageInRoom(String roomId);
}