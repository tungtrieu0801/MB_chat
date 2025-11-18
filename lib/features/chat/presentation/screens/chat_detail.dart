import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_trip_togethor/features/chat/domain/entities/message.dart';
import 'package:mobile_trip_togethor/features/chat/domain/entities/room.dart';
import 'package:mobile_trip_togethor/features/chat/presentation/bloc/chat_conversation/chat_conversation_bloc.dart';
import 'package:mobile_trip_togethor/features/chat/presentation/bloc/chat_conversation/chat_conversation_state.dart';
import 'package:mobile_trip_togethor/features/chat/presentation/bloc/chat_conversation/chat_converstaion_event.dart';

import '../../../../utils/time_util.dart';

class ChatDetail extends StatefulWidget {
  final Room room;
  const ChatDetail({super.key, required this.room});

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
    bloc.add(JoinRoomEvent(widget.room.id));
    bloc.add(GetListMessageEvent(widget.room.id));
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
      SendMessageEvent(roomId: widget.room.id, content: text),
    );

    _controller.clear();
    _scrollToBottom();
  }

  void _showReactMenu(Message message) async {
    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 100, 100),
      items: const [
        PopupMenuItem(value: '❤️', child: Text('❤️')),
        PopupMenuItem(value: '😂', child: Text('😂')),
        PopupMenuItem(value: '👍', child: Text('👍')),
        PopupMenuItem(value: '😮', child: Text('😮')),
        PopupMenuItem(value: '😢', child: Text('😢')),
        PopupMenuItem(value: '👎', child: Text('👎')),
      ],
    );

    if (selected != null) {
      context.read<ChatConversationBloc>().add(
        ReactMessageEvent(roomId: widget.room.id, messageId: message.id, reaction: selected),
      );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients && _scrollController.positions.isNotEmpty) {
        try {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        } catch (_) {
          _scrollController.jumpTo(0);
        }
      }
    });
  }

  Widget _buildMessageItem(Message message, String? currentUserId) {
    final isMine = message.senderId == currentUserId;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onLongPress: () => _showReactMenu(message),
        child: Align(
          alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isMine ? Colors.blueAccent : Colors.grey[300],
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft: isMine ? const Radius.circular(12) : const Radius.circular(0),
                bottomRight: isMine ? const Radius.circular(0) : const Radius.circular(12),
              ),
            ),
            constraints: const BoxConstraints(maxWidth: 280),
            child: Column(
              crossAxisAlignment:
              isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  message.userChat.fullname,
                  style: TextStyle(
                    fontSize: 10,
                    color: isMine ? Colors.white70 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message.content,
                  style: TextStyle(color: isMine ? Colors.white : Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  formatTimeMessage(message.createdAt.toString()),
                  style: TextStyle(color: isMine ? Colors.white : Colors.black87, fontSize: 8.sp),
                ),
                const SizedBox(height: 4),
                if (isMine)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (message.status == MessageStatus.sending)
                        const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      else if (message.status == MessageStatus.sent)
                        const Icon(Icons.check, size: 14, color: Colors.white70),
                    ],
                  ),
                if (message.reactions.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Wrap(
                      spacing: 4,
                      children:
                      message.reactions.map((r) => Text(r, style: const TextStyle(fontSize: 14))).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.room.name),
            Text(
              'Hoạt động ${widget.room.lastOnlineAt}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.call), onPressed: () {}),
          IconButton(icon: const Icon(Icons.video_call), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatConversationBloc, ChatConversationState>(
              listener: (context, state) {
                if (state is ChatConversationLoaded) _scrollToBottom();
              },
              builder: (context, state) {
                if (state is ChatConversationLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatConversationLoaded) {
                  final messages = state.messages;
                  final typingUserIds = state.typingUserIds;

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) =>
                              _buildMessageItem(messages[index], state.currentUserId),
                        ),
                      ),
                      _buildTypingIndicator(typingUserIds, state.currentUserId),
                    ],
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
                      onChanged: (text) {
                        final state = context.read<ChatConversationBloc>().state;
                        String? currentUserId;
                        if (state is ChatConversationLoaded) {
                          currentUserId = state.currentUserId;
                        }

                        if (currentUserId != null) {
                          context.read<ChatConversationBloc>().add(
                            UserTypingEvent(currentUserId, text.isNotEmpty),
                          );
                        }
                      },
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

  Widget _buildTypingIndicator(Set<String> typingUserIds, String? currentUserId) {
    final otherUsers = typingUserIds.where((id) => id != currentUserId).toList();
    if (otherUsers.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Text(
        '${otherUsers.join(', ')} đang nhập...',
        style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
      ),
    );
  }
}
