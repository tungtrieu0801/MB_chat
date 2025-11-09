import 'package:get_it/get_it.dart';
import 'package:mobile_trip_togethor/features/chat/data/datasource/room_remote_datasource.dart';
import 'package:mobile_trip_togethor/features/chat/data/repositories/room_repository_impl.dart';
import 'package:mobile_trip_togethor/features/chat/domain/repositories/room_repository.dart';
import 'package:mobile_trip_togethor/features/chat/domain/usecases/get_list_room_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';

final sl = GetIt.instance; // sl = Service Locator

Future<void> init() async {
  // --- External ---
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  // --- Data sources ---
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSource());
  sl.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<RoomRemoteDatasource>(() => RoomRemoteDatasource());

  // --- Repository ---
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<RoomRepository>(
      () => RoomRepositoryImpl(sl()),
  );

  // --- Use cases ---
  sl.registerLazySingleton<LoginUsecase>(() => LoginUsecase(sl()));
  sl.registerLazySingleton<GetListRoomUseCase>(() => GetListRoomUseCase(sl()));
}
