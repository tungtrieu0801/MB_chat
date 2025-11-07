import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_trip_togethor/features/app/presentation/main_screen.dart';
import 'package:mobile_trip_togethor/features/auth/presentation/pages/login_widget.dart';
import 'package:mobile_trip_togethor/features/chat/presentation/screens/chat_screen.dart';
import 'package:mobile_trip_togethor/features/user/presentaion/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/auth',
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
      ],
    ),

    // Standalone route for Authentication
    GoRoute(
      path: '/auth',
      builder: (context, state) =>  LoginPage(),
    ),
  ],
);
