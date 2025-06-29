import 'package:mobile_trip_togethor/features/chat/domain/entities/chat_message.dart';
import 'package:mobile_trip_togethor/features/chat/domain/repositories/chat_repository.dart';

class FetchMessageUsercase {
  final ChatRepository repository;

  FetchMessageUsercase(this.repository);

  Future<List<ChatMessage>> call(String roomId) {
    return repository.getMessage(roomId);
  }
}
