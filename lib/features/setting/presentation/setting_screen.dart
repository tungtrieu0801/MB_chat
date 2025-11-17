import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_trip_togethor/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:mobile_trip_togethor/features/setting/presentation/bloc/setting_event.dart';
import 'package:mobile_trip_togethor/features/setting/presentation/bloc/setting_state.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Settings'),
      ),
      body: BlocConsumer<SettingBloc, SettingState>(
        listener: (context, state) {
          if (state is SettingSuccess) {
            context.go('/auth');
          } else if (state is SettingError) {
            // Hiển thị lỗi nếu logout thất bại
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is SettingLoading) {
            // Hiển thị loading khi đang xử lý logout
            return Center(child: CircularProgressIndicator());
          }

          // Nút Logout mặc định
          return Center(
            child: TextButton(
              onPressed: () {
                // Gửi event Logout
                context.read<SettingBloc>().add(LogoutEvent());
              },
              child: Text(
                'Logout',
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        },
      ),
    );
  }
}
