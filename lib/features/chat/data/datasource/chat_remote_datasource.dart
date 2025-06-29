import 'package:dio/dio.dart';
import 'package:mobile_trip_togethor/features/chat/data/models/chat_message_model.dart';

class ChatRemoteDatasource {
  final Dio dio;

  ChatRemoteDatasource(this.dio);

  Future<List<ChatMessageModel>> fetchMessages(String roomId) async {
    final response = await dio.get('/aaaa');
    final List data = response.data;
    return data.map((json) => ChatMessageModel.fromJson(json)).toList();
  }
}
