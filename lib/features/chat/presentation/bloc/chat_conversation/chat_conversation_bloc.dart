import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_trip_togethor/core/network/socket_manager.dart';
import 'package:mobile_trip_togethor/features/chat/domain/entities/message.dart';
import 'package:mobile_trip_togethor/features/auth/domain/entities/user.dart';
import 'package:mobile_trip_togethor/features/chat/domain/usecases/get_list_message_usecase.dart';
import 'chat_converstaion_event.dart';
import 'chat_conversation_state.dart';
import 'package:mobile_trip_togethor/core/shared/usecases/get_cache_user_usecase.dart';

class ChatConversationBloc
    extends Bloc<ChatConversationEvent, ChatConversationState> {
  final GetCacheUserUseCase getCacheUserUseCase;
  final SocketManager socketManager;
  final GetListMessageUseCase getListMessageUseCase;

  final List<Message> _messages = [];
  User? _currentUser;

  ChatConversationBloc({
    required this.getListMessageUseCase,
    required this.socketManager,
    required this.getCacheUserUseCase,
  }) : super(ChatConversationInitial()) {
    on<GetListMessageEvent>(_onGetMessages);
    on<JoinRoomEvent>(_onJoinRoom);
    on<SendMessageEvent>(_onSendMessage);
    on<ReceiveMessageEvent>(_onReceiveMessage);
    on<UserTypingEvent>(_onUserTyping);

    // --- Thêm handler cho reaction ---
    on<ReactMessageEvent>(_onReactMessage);

    _loadCachedUser();
  }

  Future<void> _loadCachedUser() async {
    _currentUser = await getCacheUserUseCase.call();
    if (_currentUser != null) {
      socketManager.initAndConnect(userId: _currentUser!.id);
      print('Socket connected with userId: ${_currentUser!.id}');
    } else {
      print('⚠️ No cached user, socket not connected');
    }
  }

  void _onGetMessages(GetListMessageEvent event, Emitter<ChatConversationState> emit) async {
    emit(ChatConversationLoading());
    try {
      final messages = await getListMessageUseCase.getListMessageInRoom(event.roomId);
      _messages.clear();
      _messages.addAll(
          messages.map((m) => m.copyWith(status: MessageStatus.sent)) // <- override status
      );
      emit(ChatConversationLoaded(List.from(_messages), _currentUser?.id));
    } catch (e) {
      emit(ChatConversationError('Failed to load messages: $e'));
      print('Failed to load messages: $e');
    }
  }

  void _onJoinRoom(JoinRoomEvent event, Emitter<ChatConversationState> emit) async {
    try {
      await socketManager.joinRoom(event.roomId);

      socketManager.onMessage(event.roomId).listen((data) {
        add(ReceiveMessageEvent(data));
      });

      socketManager.onTyping(event.roomId).listen((data) {
        add(UserTypingEvent(data['userId'], data['isTyping']));
      });

      socketManager.onMessageReactedStream(event.roomId).listen((data) {
        add(ReactMessageEvent(
          roomId: data['roomId'],
          messageId: data['messageId'],
          reaction: data['reaction'],
          fromServer: true, // đánh dấu event từ server
        ));
      });


      print('📩 Joined room: ${event.roomId}');
    } catch (e) {
      print('❌ Join room failed: $e');
    }
  }

  void _onSendMessage(SendMessageEvent event, Emitter<ChatConversationState> emit) {
    if (_currentUser == null) return;

    final messageId = DateTime.now().millisecondsSinceEpoch.toString();

    final message = Message(
      id: messageId,
      roomId: event.roomId,
      senderId: _currentUser!.id,
      content: event.content,
      type: 'text',
      mentionedUserIds: [],
      isPinned: false,
      isEdited: false,
      isDeleted: false,
      reactions: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: MessageStatus.sending,
    );

    _messages.insert(0, message);
    emit(ChatConversationLoaded(List.from(_messages), _currentUser?.id));

    socketManager.sendMessage(event.roomId, {
      'id': messageId,
      'roomId': event.roomId,
      'senderId': _currentUser?.id,
      'content': event.content,
      'type': 'text',
      'mentionedUserIds': [],
      'isPinned': false,
      'isEdited': false,
      'isDeleted': false,
      'reactions': [],
      'createdAt': message.createdAt.toIso8601String(),
      'updatedAt': message.updatedAt.toIso8601String(),
    });
  }

  void _onReceiveMessage(ReceiveMessageEvent event, Emitter<ChatConversationState> emit) {
    final data = event.message;
    final index = _messages.indexWhere((m) => m.id == data['id']);

    if (index != -1) {
      _messages[index] = _messages[index].copyWith(
        content: data['content'],
        updatedAt: DateTime.parse(data['updatedAt']),
        status: MessageStatus.sent,
      );
    } else {
      _messages.insert(
        0,
        Message(
          id: data['id'],
          roomId: data['roomId'],
          senderId: data['senderId'],
          content: data['content'],
          type: 'text',
          mentionedUserIds: [],
          isPinned: false,
          isEdited: false,
          isDeleted: false,
          reactions: [],
          createdAt: DateTime.parse(data['createdAt']),
          updatedAt: DateTime.parse(data['updatedAt']),
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

  // --- Xử lý reaction ---
  void _onReactMessage(ReactMessageEvent event, Emitter<ChatConversationState> emit) {
    if (state is! ChatConversationLoaded) return;

    final currentState = state as ChatConversationLoaded;

    final updatedMessages = currentState.messages.map((msg) {
      if (msg.id == event.messageId) {
        final newReactions = List<String>.from(msg.reactions!);

        // Nếu reaction chưa tồn tại thì thêm
        if (!newReactions.contains(event.reaction)) {
          newReactions.add(event.reaction);
        }

        // Chỉ gửi lên server nếu event từ UI, không phải server
        if (!event.fromServer) {
          socketManager.reactMessage(event.roomId, {
            'messageId': msg.id,
            'reaction': event.reaction,
            'roomId': event.roomId,
            'userId': currentState.currentUserId,
          });
        }

        return msg.copyWith(reactions: newReactions);
      }
      return msg;
    }).toList();

    emit(ChatConversationLoaded(
      updatedMessages,
      currentState.currentUserId,
      currentState.typingUserIds,
    ));
  }


}
