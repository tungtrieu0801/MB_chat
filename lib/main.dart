import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/router/app_router.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  // --- Khởi tạo các dependency (DI thủ công, có thể dùng get_it sau) ---
  final remoteDataSource = AuthRemoteDataSource();
  final localDataSource = AuthLocalDataSourceImpl(prefs);
  final repository = AuthRepositoryImpl(remoteDataSource, localDataSource);
  final loginUsecase = LoginUsecase(repository);

  final cachedUser = await repository.getCachedUser();

  runApp(MyApp(
    loginUsecase: loginUsecase,
  ));
}

class MyApp extends StatelessWidget {
  final LoginUsecase loginUsecase;

  const MyApp({super.key, required this.loginUsecase});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Inject AuthBloc vào widget tree
        BlocProvider(
          create: (_) => AuthBloc(loginUsecase),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, __) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: 'Inter'),
            routerConfig: router
          );
        },
      ),
    );
  }
}
