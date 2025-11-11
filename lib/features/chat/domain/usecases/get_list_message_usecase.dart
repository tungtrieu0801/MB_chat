import 'package:mobile_trip_togethor/features/chat/domain/entities/message.dart';
import 'package:mobile_trip_togethor/features/chat/domain/repositories/message_repository.dart';

class GetListMessageUseCase {
  final MessageRepository repository;

  GetListMessageUseCase(this.repository);

  Future<List<Message>> getListMessageInRoom(String roomId) {
    return repository.getListMessageInRoom(roomId);
  }
}