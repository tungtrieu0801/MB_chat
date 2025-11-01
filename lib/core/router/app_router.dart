import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_trip_togethor/features/auth/presentation/screens/auth_screen.dart';
import 'package:mobile_trip_togethor/features/chat/presentation/screens/chat_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/chat',
  routes: [
    GoRoute(
      path: '/chat',
      builder: (context, state) => ChatScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => AuthScreen(),
    ),
    // GoRoute(
    //   path: '/detail/:id',
    //   builder: (context, state) {
    //     final id = state.pathParameters['id'];
    //     return DetailScreen(id: id);
    //   },
    // ),
  ],
);