import 'package:dio/dio.dart';
import 'package:mobile_trip_togethor/core/constants/api_endpoint.dart';
import 'package:mobile_trip_togethor/core/model/api_response_model.dart';
import 'package:mobile_trip_togethor/core/network/dio_client.dart';
import 'package:mobile_trip_togethor/features/profile/data/models/profile_detail_model.dart';
import 'package:mobile_trip_togethor/features/profile/data/models/profile_qr_model.dart';

class ProfileRemoteDataSource {
  final Dio dio = DioClient.instance;

  Future<ProfileQrModel> generateTemToken(String fullName, String avatarUrl) async {
   final response = await dio.post(
     ApiEndpoint.generatedQR,
     data: {
       'fullName': fullName,
       'avatarUrl': avatarUrl,
     },
   );
   return ProfileQrModel.fromJson(response.data);
  }

  Future<ProfileDetailModel?> getUserDetail() async {
    final response = await dio.get(ApiEndpoint.getUserDetail);

    final apiResponse = ApiResponse<ProfileDetailModel>.fromJson(
      response.data,
          (dataJson) => ProfileDetailModel.fromJson(dataJson),
    );

    return apiResponse.data;
  }

}