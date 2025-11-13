import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_trip_togethor/features/chat/presentation/screens/widgets/calling_widget.dart';
import 'package:mobile_trip_togethor/features/chat/presentation/screens/widgets/imcoming_call_widget.dart';
import 'package:mobile_trip_togethor/features/chat/presentation/screens/widgets/in_call_widget.dart';

import '../bloc/video_call/video_call_bloc.dart';
import '../bloc/video_call/video_call_event.dart';
import '../bloc/video_call/video_call_state.dart';

class VideoCallScreen extends StatelessWidget {
  const VideoCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CallBloc, CallState>(
      builder: (context, state) {
        switch (state.status) {
          case CallStatus.incoming:
            return IncomingCallWidget(
              callerName: state.peerName ?? 'Người gọi',
              callerAvatar: state.peerAvatar,
              onAccept: () async {
                final sdpAnswer = await context.read<CallBloc>().createAnswer();
                context.read<CallBloc>().add(CallAnswerEvent(state.peerId!, sdpAnswer));
              },

              onReject: () => context.read<CallBloc>().add(
                CallHangupEvent(state.peerId!),
              ),
            );
          case CallStatus.calling:
            return CallingWidget(
              peerName: state.peerName ?? 'Đang gọi...',
            );
          case CallStatus.inCall:
            return InCallWidget(peerId: state.peerId!);
          default:
            return Scaffold(
              body: Center(child: Text('Chờ kết nối...')),
            );
        }
      },
    );
  }
}
