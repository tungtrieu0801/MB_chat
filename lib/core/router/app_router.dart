import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_trip_togethor/features/app/presentation/main_screen.dart';
import 'package:mobile_trip_togethor/features/auth/data/datasources/impl/auth_local_datasource_impl.dart';
import 'package:mobile_trip_togethor/features/auth/presentation/pages/login_widget.dart';
import 'package:mobile_trip_togethor/features/chat/presentation/bloc/chat_conversation/chat_conversation_bloc.dart';
import 'package:mobile_trip_togethor/features/chat/presentation/bloc/chat_conversation/chat_converstaion_event.dart';
import 'package:mobile_trip_togethor/features/chat/presentation/screens/chat_detail.dart';
import 'package:mobile_trip_togethor/features/chat/presentation/screens/chat_list_screen.dart';
import 'package:mobile_trip_togethor/features/profile/presentaion/pages/qr_code_screen.dart';
import 'package:mobile_trip_togethor/features/splash/presentaion/page/splash_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/profile/presentaion/pages/profile_screen.dart';


final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

Future<AuthLocalDataSource> initAuthLocalDataSource() async {
  final prefs = await SharedPreferences.getInstance();
  return AuthLocalDataSourceImpl(prefs);
}

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    // ShellRoute for the main app navigation (with BottomNavBar)
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return MainScreen(child: child);
      },
      routes: <RouteBase>[
        // Route for the Chat screen (Home tab)
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const ChatScreen();
          },
        ),
        // Route for the Profile screen
        GoRoute(
          path: '/profile',
          builder: (BuildContext context, GoRouterState state) {
            return ProfileScreen();
          },
        ),
        GoRoute(
          path: '/chat/:roomId',
          builder: (context, state) {
            final roomId = state.pathParameters['roomId']!;
            // Gửi event load message khi mở phòng
            context.read<ChatConversationBloc>().add(GetListMessageEvent(roomId));
            return ChatDetail(roomId: roomId);
          },
        ),
      ],
    ),

    // Standalone route for Authentication
    GoRoute(
      path: '/auth',
      builder: (context, state) =>  LoginPage(),
    ),
    GoRoute(
      path: '/splash',
      builder: (context, state) => FutureBuilder<AuthLocalDataSource>(
        future: initAuthLocalDataSource(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Scaffold(
              body: Center(child: Text('Failed to init')),
            );
          }
          return SplashScreen(authLocalDataSource: snapshot.data!);
        },
      ),
    ),
    GoRoute(
      path: '/qrcode',
      builder: (context, state) =>  QrCodeScreen(),
    ),
  ],
);