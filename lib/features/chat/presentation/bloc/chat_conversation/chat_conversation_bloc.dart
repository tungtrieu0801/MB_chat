import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_trip_togethor/core/network/socket_manager.dart';
import 'package:mobile_trip_togethor/features/auth/domain/entities/user.dart';
import 'package:mobile_trip_togethor/core/shared/usecases/get_cache_user_usecase.dart';
import 'chat_conversation_state.dart';
import 'chat_converstaion_event.dart';

class ChatConversationBloc
    extends Bloc<ChatConversationEvent, ChatConversationState> {
  final GetCacheUserUseCase getCacheUserUseCase;
  final SocketManager socketManager;
  final List<Message> _messages = [];
  User? _currentUser;

  ChatConversationBloc({required this.socketManager, required this.getCacheUserUseCase})
      : super(ChatConversationInitial()) {
    on<GetListMessageEvent>(_onGetMessages);
    on<JoinRoomEvent>(_onJoinRoom);
    on<SendMessageEvent>(_onSendMessage);
    on<ReceiveMessageEvent>(_onReceiveMessage);
    on<UserTypingEvent>(_onUserTyping);
    _loadCachedUser();
  }

  Future<void> _loadCachedUser() async {
    final result = await getCacheUserUseCase.call();
    _currentUser = result;
    print('Current user: ${_currentUser?.id}');
  }

  void _onGetMessages(
      GetListMessageEvent event, Emitter<ChatConversationState> emit) async {
    emit(ChatConversationLoading());
    try {
      // Nếu muốn load từ repo, có thể thêm ở đây
      emit(ChatConversationLoaded(List.from(_messages), _currentUser?.id));
    } catch (e) {
      emit(ChatConversationError(e.toString()));
    }
  }

  void _onJoinRoom(
      JoinRoomEvent event, Emitter<ChatConversationState> emit) async {
    try {
      await socketManager.joinRoom(event.roomId);
      // Lắng nghe message chỉ của room này
      socketManager.onMessage(event.roomId).listen((data) {
        add(ReceiveMessageEvent(data));
      });
      socketManager.onTyping(event.roomId).listen((data) {
        add(UserTypingEvent(data['userId'], data['isTyping']));
      });
      print('📩 Joined room: ${event.roomId}');
    } catch (e) {
      print('❌ Join room failed: $e');
    }
  }

  void _onSendMessage(
      SendMessageEvent event, Emitter<ChatConversationState> emit) {
    final messageId = DateTime.now().millisecondsSinceEpoch.toString();

    final message = Message(
      id: messageId,
      roomId: event.roomId,
      senderId: _currentUser!.id,
      content: event.content,
      createdAt: DateTime.now(),
      status: MessageStatus.sending,
    );

    _messages.insert(0, message);
    emit(ChatConversationLoaded(List.from(_messages), _currentUser?.id));


    // Gửi lên server
    socketManager.sendMessage(event.roomId, {
      'id': messageId,
      'roomId': event.roomId,
      'senderId': _currentUser?.id,
      'content': event.content,
      'createdAt': message.createdAt.toIso8601String(),
    });
  }


  void _onReceiveMessage(
      ReceiveMessageEvent event, Emitter<ChatConversationState> emit) {
    final data = event.message;

    // Tìm message đang gửi với cùng id, cập nhật content & status
    final index = _messages.indexWhere((m) => m.id == data['id']);
    if (index != -1) {
      // Cập nhật tin nhắn client thành server said
      _messages[index] = Message(
        id: data['id'],
        roomId: data['roomId'],
        senderId: data['senderId'],
        content: data['content'], // "server said: ..."
        createdAt: DateTime.parse(data['createdAt']),
        status: MessageStatus.sent,
      );
    } else {
      // Tin nhắn mới từ server, insert bình thường
      _messages.insert(
        0,
        Message(
          id: data['id'],
          roomId: data['roomId'],
          senderId: data['senderId'],
          content: data['content'],
          createdAt: DateTime.parse(data['createdAt']),
          status: MessageStatus.received,
        ),
      );
    }

    emit(ChatConversationLoaded(List.from(_messages), _currentUser?.id));
  }

  void _onUserTyping(UserTypingEvent event, Emitter<ChatConversationState> emit) {
    if (state is ChatConversationLoaded) {
      final currentState = state as ChatConversationLoaded;
      final updatedTypingIds = Set<String>.from(currentState.typingUserIds);

      if (event.isTyping) {
        updatedTypingIds.add(event.userId);
      } else {
        updatedTypingIds.remove(event.userId);
      }

      emit(ChatConversationLoaded(
        currentState.messages,
        currentState.currentUserId,
        updatedTypingIds,
      ));
    }
  }


}
