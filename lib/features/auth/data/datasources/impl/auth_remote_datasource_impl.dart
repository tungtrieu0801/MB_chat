import 'package:dio/dio.dart';
import 'package:mobile_trip_togethor/core/constants/api_endpoint.dart';
import 'package:mobile_trip_togethor/core/model/api_response_model.dart';
import 'package:mobile_trip_togethor/core/network/dio_client.dart';
import 'package:mobile_trip_togethor/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mobile_trip_togethor/features/auth/data/models/user_model.dart';
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio = DioClient.instance;

  Future<LoginResponseModel?> login(String username, String password) async {
    final response = await dio.post(
      ApiEndpoint.loginUrl,
      data: {
        'username': username,
        'password': password,
      },
    );
    print("Aaaaa");
    print(response);
    final dataLogin = ApiResponse<LoginResponseModel>.fromJson(
      response.data,
          (dataJson) => LoginResponseModel.fromJson(dataJson),
    );
    print("bbbb");
    print(dataLogin);
    return dataLogin.data;
  }
}