import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_trip_togethor/core/network/socket_manager.dart';
import 'package:mobile_trip_togethor/core/shared/usecases/clear_cache_user_usecase.dart';
import 'package:mobile_trip_togethor/core/shared/usecases/get_cache_user_usecase.dart';
import 'package:mobile_trip_togethor/features/chat/presentation/bloc/chat_conversation/chat_conversation_bloc.dart';
import 'package:mobile_trip_togethor/features/setting/presentation/bloc/setting_bloc.dart';

import 'core/router/app_router.dart';
import 'core/di/injection_container.dart' as di;
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/chat/domain/usecases/get_list_message_usecase.dart';
import 'features/chat/presentation/bloc/video_call/video_call_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // --- Khởi tạo Dependency Injection ---
  await di.init();
  // final socketManager = di.sl<SocketManager>();
  // final getCacheUserUseCase = di.sl<GetCacheUserUseCase>();
  // final cacheUser = await getCacheUserUseCase();
  // final userId = cacheUser?.id;
  // // Make sure socket init and connect before UI render.
  // if (userId != null) {
  //   socketManager.initAndConnect(userId: userId);
  //   print('Send userId: ${userId} to socket');
  // } else {
  //   print('can not get userId to send to socket');
  // }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(di.sl<LoginUsecase>(), di.sl<SocketManager>()),
        ),
        BlocProvider(
          create: (_) => ChatConversationBloc(
            socketManager: di.sl<SocketManager>(),
            getCacheUserUseCase: di.sl<GetCacheUserUseCase>(),
            getListMessageUseCase: di.sl<GetListMessageUseCase>(),
          ),
        ),
        BlocProvider(
          create: (_) => SettingBloc(di.sl<ClearCacheUserUseCase>()),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (_, __) => MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Inter'),
          routerConfig: router,
        ),
      ),
    );
  }
}
