import 'package:dio/dio.dart';
import 'package:mobile_trip_togethor/core/network/dio_client.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final Dio dio = DioClient.instance;

  Future<UserModel> login(String username, String password) async {
    final response = await dio.post(
      '/auth/login', // baseUrl đã có trong DioClient
      data: {
        'username': username,
        'password': password,
      },
    );
    return UserModel.fromJson(response.data);
  }
}
