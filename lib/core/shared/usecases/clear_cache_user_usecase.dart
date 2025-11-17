import 'package:mobile_trip_togethor/core/shared/repository/user_cache_repository.dart';

class ClearCacheUserUseCase {
  final UserCacheRepository repository;

  ClearCacheUserUseCase(this.repository);

  Future<void> clearCacheUser() async {
    await repository.clearCache();
  }
}