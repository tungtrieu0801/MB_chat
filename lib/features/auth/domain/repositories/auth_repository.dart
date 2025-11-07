import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String username, String password);
  /// Lấy profile đã cache (nếu có)
  Future<User?> getCachedUser();

  /// Xóa cache profile
  Future<void> clearCache();
}
