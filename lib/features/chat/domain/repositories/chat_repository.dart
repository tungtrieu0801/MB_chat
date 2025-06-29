import 'package:mobile_trip_togethor/features/chat/domain/entities/chat_message.dart';

abstract class ChatRepository {
  Future<List<ChatMessage>> getMessage(String roomId);
}
