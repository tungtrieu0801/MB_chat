import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_trip_togethor/core/widgets/main_bottom_navigation_bar.dart';

class MainScreen extends StatelessWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  // Determine the selected index based on the current route
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location == '/') {
      return 0;
    } 
    if (location == '/profile') {
      return 1;
    }
    return 0; // Default index
  }

  // Navigate to the correct screen when a tab is tapped
  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        // You should create a route for '/profile' in your app_router.dart
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child, // The child is the screen provided by GoRouter
      bottomNavigationBar: MainBottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
      ),
    );
  }
}
