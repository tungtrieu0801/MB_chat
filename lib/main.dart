import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_trip_togethor/core/network/socket_manager.dart';
import 'package:mobile_trip_togethor/core/shared/usecases/get_cache_user_usecase.dart';
import 'package:mobile_trip_togethor/features/chat/presentation/bloc/chat_conversation/chat_conversation_bloc.dart';

import 'core/router/app_router.dart';
import 'core/di/injection_container.dart' as di;
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/chat/presentation/bloc/video_call/video_call_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // --- Khởi tạo Dependency Injection ---
  await di.init();
  final socketManager = di.sl<SocketManager>();

  // Make sure socket init and connect before UI render.
  socketManager.initAndConnect();
  runApp(MyApp(socketManager: socketManager));
}

class MyApp extends StatelessWidget {
  final SocketManager socketManager;
  const MyApp({super.key, required this.socketManager});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(di.sl<LoginUsecase>()),
        ),
        BlocProvider(
          create: (_) => ChatConversationBloc(
              socketManager: socketManager,
            getCacheUserUseCase: di.sl<GetCacheUserUseCase>(),
          ),
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
