import 'package:dio/dio.dart';
import 'package:mobile_trip_togethor/core/constants/api_endpoint.dart';
import 'package:mobile_trip_togethor/core/model/api_response_model.dart';
import 'package:mobile_trip_togethor/core/network/dio_client.dart';
import 'package:mobile_trip_togethor/features/chat/data/models/room_model.dart';

class RoomRemoteDatasource {
  final Dio dio = DioClient.instance;

  Future<List<ChatRoomModel>> getListRoom() async {
    try {
      final response = await dio.get(ApiEndpoint.getListRoom);

      // Sửa lại hàm callback (fromJsonT)
      final listRoom = ApiResponse<List<ChatRoomModel>>.fromJson(
        response.data,
            (dataJson) { // dataJson lúc này là dynamic, ta ép kiểu thành List
          // Ép kiểu dataJson thành List và map qua từng phần tử
          return (dataJson as List)
              .map((e) => ChatRoomModel.fromJson(e as Map<String, dynamic>))
              .toList();
        },
      );

      return listRoom.data ?? [];
    } on DioException catch (e) {
      throw Exception('Lỗi khi gọi API: ${e.message}');
    } catch (e) {
      throw Exception('Lỗi không xác định: $e');
    }
  }
}