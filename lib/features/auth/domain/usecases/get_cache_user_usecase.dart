import 'package:mobile_trip_togethor/features/auth/domain/entities/user.dart';
import 'package:mobile_trip_togethor/features/auth/domain/repositories/auth_repository.dart';

class GetCacheUserUseCase {
  final AuthRepository repository;

  GetCacheUserUseCase(this.repository);

  Future<User?> call() async {
    return await repository.getCachedUser();
  }
}