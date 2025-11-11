import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_trip_togethor/features/chat/domain/usecases/get_list_message_usecase.dart';
import 'package:mobile_trip_togethor/features/chat/presentation/bloc/chat_conversation/chat_conversation_state.dart';
import 'package:mobile_trip_togethor/features/chat/presentation/bloc/chat_conversation/chat_converstaion_event.dart';
import '../../../../../core/di/injection_container.dart';

class ChatConversationBloc extends Bloc<ChatConversationEvent, ChatConversationState> {
  final GetListMessageUseCase _getListMessageUseCase = sl<GetListMessageUseCase>();

  // Bạn có thể giữ socket connection ở đây
  // late final ChatSocketClient _socketClient;

  ChatConversationBloc() : super(ChatConversationInitial()) {
    on<GetListMessageEvent>(_onGetMessages);
    // on<NewMessageReceivedEvent>(_onNewMessageReceived);
  }

  Future<void> _onGetMessages(GetListMessageEvent event, Emitter<ChatConversationState> emit) async {
    emit(ChatConversationLoading());
    try {
      final messages = await _getListMessageUseCase.getListMessageInRoom(event.roomId);
      emit(ChatConversationLoaded(messages));
    } catch (e) {
      emit(ChatConversationError(e.toString()));
    }
  }

// Future<void> _onNewMessageReceived(NewMessageReceivedEvent event, Emitter<ChatConversationState> emit) async {
//   if (state is ChatConversationLoaded) {
//     final updatedMessages = List.of((state as ChatConversationLoaded).messages)
//       ..insert(0, event.message);
//     emit(ChatConversationLoaded(updatedMessages));
//   }
// }
}
