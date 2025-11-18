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
        id: userModel!.id,
        username: userModel!.username,
        email: userModel!.email,
        phoneNumber: userModel!.phoneNumber,
        accessToken: userModel.accessToken,
        avatar: userModel!.avatar,
        fullName: userModel.fullName,
      );

      // Lưu vào local cache (SharedPreferences)
      await localDataSource.cacheUser(user);
      await localDataSource.saveToken(user.accessToken);
      print('User saved to cache: id=${user.id}, username=${user.username}, email=${user.email}, accessToken=${user.accessToken}');

      return user;
    } catch (e) {
      rethrow;
    }
  }

}
