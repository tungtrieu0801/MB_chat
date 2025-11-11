import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_trip_togethor/features/chat/presentation/bloc/chat_conversation/chat_conversation_bloc.dart';
import 'package:mobile_trip_togethor/features/chat/presentation/bloc/chat_conversation/chat_conversation_state.dart';

class ChatDetail extends StatelessWidget {
  final String roomId;

  const ChatDetail({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Phòng chat $roomId')),
      body: BlocBuilder<ChatConversationBloc, ChatConversationState>(
        builder: (context, state) {
          if (state is ChatConversationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatConversationLoaded) {
            final messages = state.messages;
            return ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(message.content ?? 'Unknown'),
                  subtitle: Text(message.content),
                );
              },
            );
          } else if (state is ChatConversationError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

