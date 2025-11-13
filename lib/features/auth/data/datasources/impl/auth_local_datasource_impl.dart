import 'package:mobile_trip_togethor/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:mobile_trip_togethor/features/auth/data/models/user_model.dart';
import 'package:mobile_trip_togethor/features/auth/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String cachedUserKey = 'CACHED_USER';

  AuthLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheUser(User user) async {
    final userModel = LoginResponseModel.fromEntity(user);
    await sharedPreferences.setString(cachedUserKey, userModel.toJsonString());
  }

  @override
  Future<User?> getCachedUser() async {
    final jsonString = sharedPreferences.getString(cachedUserKey);
    if (jsonString != null) {
      final userModel = LoginResponseModel.fromJsonString(jsonString);
      return userModel.toEntity();
    }
    return null;
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(cachedUserKey);
  }

  @override
  Future<void> saveToken(String token) async{
    await sharedPreferences.setString('access_token', token);
  }
}