import 'package:dio/dio.dart';
import 'package:mobile_trip_togethor/core/constants/api_endpoint.dart';
import 'package:mobile_trip_togethor/core/model/api_response_model.dart';
import 'package:mobile_trip_togethor/core/network/dio_client.dart';
import 'package:mobile_trip_togethor/features/chat/data/models/message_model.dart';

class MessageRemoteDataSource {
  final Dio dio = DioClient.instance;

  Future<List<MessageModel>> getListMessage(String roomId, {int page = 1, int limit = 20}) async {
    try {
      // ✅ Gọi đúng endpoint kèm roomId, page, limit
      final response = await dio.get(
        ApiEndpoint.getListMessageInRoom(roomId, page, limit),
      );

      // ✅ Parse dữ liệu JSON trả về
      final listMessageInRoom = ApiResponse<List<MessageModel>>.fromJson(
        response.data,
            (dataJson) {
          return (dataJson as List)
              .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
              .toList();
        },
      );

      return listMessageInRoom.data ?? [];
    } on DioException catch (e) {
      throw Exception('Lỗi khi gọi API: ${e.message}');
    } catch (e) {
      throw Exception('Lỗi không xác định: $e');
    }
  }
}
