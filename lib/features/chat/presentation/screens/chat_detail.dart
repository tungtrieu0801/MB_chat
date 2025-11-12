import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_trip_togethor/features/chat/presentation/bloc/chat_conversation/chat_conversation_bloc.dart';
import 'package:mobile_trip_togethor/features/chat/presentation/bloc/chat_conversation/chat_conversation_state.dart';
import 'package:mobile_trip_togethor/features/chat/presentation/bloc/chat_conversation/chat_converstaion_event.dart';

class ChatDetail extends StatefulWidget {
  final String roomId;
  const ChatDetail({super.key, required this.roomId});

  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final bloc = context.read<ChatConversationBloc>();

    // 1️⃣ Join room
    bloc.add(JoinRoomEvent(widget.roomId));

    // 2️⃣ Load message
    bloc.add(GetListMessageEvent(widget.roomId));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    context.read<ChatConversationBloc>().add(
      SendMessageEvent(roomId: widget.roomId, content: text),
    );

    _controller.clear();
  }

  Widget _buildMessageItem(Message message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: Text(message.content)),
          if (message.senderId == 'me')
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: () {
                switch (message.status) {
                  case MessageStatus.sending:
                    return const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  case MessageStatus.sent:
                    return const Icon(Icons.check, size: 16, color: Colors.green);
                  case MessageStatus.received:
                    return const SizedBox.shrink();
                }
              }(),
            ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Phòng chat ${widget.roomId}')),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatConversationBloc, ChatConversationState>(
              listener: (context, state) {
                if (state is ChatConversationLoaded) {
                  // Cuộn xuống khi có tin nhắn mới
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      _scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOut,
                      );
                    }
                  });
                }
              },
              builder: (context, state) {
                if (state is ChatConversationLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatConversationLoaded) {
                  final messages = state.messages;
                  return ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return _buildMessageItem(messages[index]);
                    },
                  );
                } else if (state is ChatConversationError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Nhập tin nhắn...',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blueAccent,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
