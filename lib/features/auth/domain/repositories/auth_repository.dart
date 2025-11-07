import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String username, String password);
  /// Lấy user đã cache (nếu có)
  Future<User?> getCachedUser();

  /// Xóa cache user
  Future<void> clearCache();
}
