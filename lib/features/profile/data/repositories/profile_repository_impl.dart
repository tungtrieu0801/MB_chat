import 'package:mobile_trip_togethor/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:mobile_trip_togethor/features/profile/data/models/profile_qr_model.dart';
import 'package:mobile_trip_togethor/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);
  
  @override
  Future<ProfileQrModel> generatedQR(String fullName, String avatarUrl) async {
    try {
      final response = await remoteDataSource.generateTemToken(fullName, avatarUrl);
      final temporaryToken = ProfileQrModel(
          fullName: response.fullName,
          avatarUrl: response.avatarUrl,
      );
      return temporaryToken;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

}