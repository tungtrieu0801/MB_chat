// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mobile_trip_togethor/features/chat/domain/usecases/get_list_room_usecase.dart';
// import 'package:mobile_trip_togethor/features/chat/presentation/bloc/chat_event.dart';
//
// class ChatBloc extends Bloc<ChatEvent, ChatState> {
//   final GetListRoomUseCase getListRoomUseCase;
//
//   ChatBloc(this.fetchMessages) : super(ChatInitial()) {
//     on<LoadChat>((event, emit) async {
//       emit(ChatLoading());
//       try {
//         final messages = await fetchMessages(event.roomId);
//         emit(ChatLoaded(messages));
//       } catch (e) {
//         emit(ChatError('Không tải được tin nhắn'));
//       }
//     });
//
//   }
// }
