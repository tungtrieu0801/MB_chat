import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../auth/data/datasources/auth_local_data_source.dart';
import '../../../auth/domain/entities/user.dart';

class SplashScreen extends StatefulWidget {
  final AuthLocalDataSource authLocalDataSource;

  const SplashScreen({Key? key, required this.authLocalDataSource}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _initSplash();
  }

  Future<void> _initSplash() async {
    // Đợi animation hiển thị khoảng 2 giây
    await Future.delayed(const Duration(seconds: 2));

    // Kiểm tra nếu widget còn mounted
    if (!mounted) return;

    final User? cachedUser = await widget.authLocalDataSource.getCachedUser();

    if (!mounted) return;

    // Chuyển hướng an toàn với GoRouter
    if (cachedUser != null) {
      print('Cached profile found: ${cachedUser.toString()}');
      context.go('/');       // Home
    } else {
      print('No cached profile found');
      context.go('/auth');   // Login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          'assets/splash_animation.json',
          width: 200,
          height: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
