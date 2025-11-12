
import 'package:mobile_trip_togethor/features/auth/domain/entities/user.dart';

abstract class UserCacheRepository {
  /// Lấy profile đã cache (nếu có)
  Future<User?> getCachedUser();

  /// Xóa cache profile
  Future<void> clearCache();
}