import 'package:mobile_trip_togethor/core/shared/repository/user_cache_repository.dart';
import 'package:mobile_trip_togethor/features/auth/domain/entities/user.dart';

import '../datasources/auth_local_data_source.dart'; // DataSource nội bộ Auth

class UserCacheRepositoryImpl implements UserCacheRepository {
  final AuthLocalDataSource localDataSource;

  UserCacheRepositoryImpl(this.localDataSource);

  @override
  Future<User?> getCachedUser() async {
    return await localDataSource.getCachedUser();
  }

  @override
  Future<void> clearCache() async {
    await localDataSource.clearCache();
  }
}