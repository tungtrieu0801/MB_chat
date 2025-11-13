import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/video_call/video_call_bloc.dart';
import '../../bloc/video_call/video_call_event.dart';

class CallingWidget extends StatelessWidget {
  final String peerName;
  const CallingWidget({super.key, required this.peerName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Đang gọi $peerName...', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            FloatingActionButton(
              onPressed: () {
                context.read<CallBloc>().add(CallHangupEvent('peerId'));
              },
              backgroundColor: Colors.red,
              child: Icon(Icons.call_end),
            ),
          ],
        ),
      ),
    );
  }
}
