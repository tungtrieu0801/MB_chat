import 'package:mobile_trip_togethor/features/chat/data/datasource/chat_remote_datasource.dart';
import 'package:mobile_trip_togethor/features/chat/data/models/chat_message_model.dart';
import 'package:mobile_trip_togethor/features/chat/domain/entities/chat_message.dart';
import 'package:mobile_trip_togethor/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDatasource remoteDatasource;

  ChatRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<ChatMessage>> getMessage(String roomId) {
    final models = await remoteDatasource.fetchMessages(roomId);
    return models.map((m) => m).toList();
  }
}
