import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<User> login(String username, String password) async {
    try {
      final userModel = await remoteDataSource.login(username, password);

      final user = User(
        id: userModel.id,
        username: userModel.username,
        email: userModel.email,
        phoneNumber: userModel.phoneNumber,
        accessToken: userModel.accessToken,
        avatar: userModel.avatar,
      );

      // Lưu vào local cache (SharedPreferences)
      await localDataSource.cacheUser(user);

      print('User saved to cache: id=${user.id}, username=${user.username}, email=${user.email}, accessToken=${user.accessToken}');

      return user;
    } catch (e) {
      // Bạn có thể custom Exception ở đây nếu muốn
      rethrow;
    }
  }

  /// Trả về user đã lưu (nếu có) — null nếu chưa có
  Future<User?> getCachedUser() async {
    try {
      return await localDataSource.getCachedUser();
    } catch (e) {
      // xử lý/ghi log nếu cần
      return null;
    }
  }

  /// Xóa cache user (dùng cho logout)
  Future<void> clearCache() async {
    try {
      await localDataSource.clearCache();
    } catch (e) {
      // xử lý/ghi log nếu cần
      rethrow;
    }
  }
}
