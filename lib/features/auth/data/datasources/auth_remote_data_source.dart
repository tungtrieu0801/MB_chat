import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel?> login(String username, String password);
}
