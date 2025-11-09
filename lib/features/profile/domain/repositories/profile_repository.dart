import 'package:mobile_trip_togethor/features/profile/data/models/profile_qr_model.dart';

abstract class ProfileRepository {
  Future<ProfileQrModel> generatedQR(String fullName, String avatarUrl);
}