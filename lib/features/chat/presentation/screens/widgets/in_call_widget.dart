import 'package:flutter/material.dart';

class InCallWidget extends StatelessWidget {
  final String peerId;
  const InCallWidget({super.key, required this.peerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Call với $peerId đang diễn ra...'),
      ),
    );
  }
}
