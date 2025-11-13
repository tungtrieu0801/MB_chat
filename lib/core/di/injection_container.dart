import 'package:get_it/get_it.dart';
import 'package:mobile_trip_togethor/core/network/socket_manager.dart';
import 'package:mobile_trip_togethor/core/shared/repository/user_cache_repository.dart';
import 'package:mobile_trip_togethor/core/shared/usecases/get_cache_user_usecase.dart';
import 'package:mobile_trip_togethor/features/auth/data/datasources/impl/auth_remote_datasource_impl.dart';
import 'package:mobile_trip_togethor/features/auth/data/repositories/user_cache_repository_impl.dart';
import 'package:mobile_trip_togethor/features/chat/data/datasource/message_remote_datasource.dart';
import 'package:mobile_trip_togethor/features/chat/data/datasource/room_remote_datasource.dart';
import 'package:mobile_trip_togethor/features/chat/data/datasource/socker_remote_datasource.dart';
import 'package:mobile_trip_togethor/features/chat/data/repositories/message_repository_impl.dart';
import 'package:mobile_trip_togethor/features/chat/data/repositories/room_repository_impl.dart';
import 'package:mobile_trip_togethor/features/chat/domain/repositories/message_repository.dart';
import 'package:mobile_trip_togethor/features/chat/domain/repositories/room_repository.dart';
import 'package:mobile_trip_togethor/features/chat/domain/usecases/get_list_message_usecase.dart';
import 'package:mobile_trip_togethor/features/chat/domain/usecases/get_list_room_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/impl/auth_local_datasource_impl.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // --- External ---
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);

  // --- Data sources ---
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl());
  sl.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<RoomRemoteDatasource>(() => RoomRemoteDatasource());
  sl.registerLazySingleton<MessageRemoteDataSource>(() => MessageRemoteDataSource());

  // --- Repository ---
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<RoomRepository>(
      () => RoomRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<MessageRepository>(
      () => MessageRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<UserCacheRepository>(
        () => UserCacheRepositoryImpl(sl()),
  );

  // --- Use cases ---
  sl.registerLazySingleton<LoginUsecase>(() => LoginUsecase(sl()));
  sl.registerLazySingleton<GetListRoomUseCase>(() => GetListRoomUseCase(sl()));
  sl.registerLazySingleton<GetListMessageUseCase>(() => GetListMessageUseCase(sl()));
  sl.registerLazySingleton<GetCacheUserUseCase>(() => GetCacheUserUseCase(sl()));

  // Socket manager singleton
  sl.registerLazySingleton<SocketManager>(() => SocketManager());

  // Socket remote datasource
  sl.registerLazySingleton<SocketRemoteDataSource>(() => SocketRemoteDataSourceImpl(sl(), sl()));
}
