import 'package:dio/dio.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<UserModel> login(String username, String password) async {
    final response = await dio.post(
      'http://localhost:3000/auth/login',
      data: {
        'username': username,
        'password': password,
      },
      options: Options(headers: {
        'Content-Type': 'application/json',
      }),
    );

    // API của bạn có dạng: { code, message, data }
    return UserModel.fromJson(response.data);
  }
}
