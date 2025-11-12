import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
        actions: [
          IconButton(
            onPressed: () {
              context.push("/search");
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}
