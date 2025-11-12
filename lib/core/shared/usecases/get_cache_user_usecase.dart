import 'package:mobile_trip_togethor/core/shared/repository/user_cache_repository.dart';
import 'package:mobile_trip_togethor/features/auth/domain/entities/user.dart';

class GetCacheUserUseCase {
  final UserCacheRepository repository;

  GetCacheUserUseCase(this.repository);

  Future<User?> call() async {
    return await repository.getCachedUser();
  }
}