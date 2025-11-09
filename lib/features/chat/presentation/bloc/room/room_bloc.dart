import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_trip_togethor/features/chat/domain/usecases/get_list_room_usecase.dart';
import '../../../../../core/di/injection_container.dart';
import 'room_event.dart';
import 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final GetListRoomUseCase _getListRoomUseCase = sl<GetListRoomUseCase>();

  RoomBloc() : super(RoomInitial()) {
    on<GetRoomsEvent>(_onGetRooms);
  }

  Future<void> _onGetRooms(GetRoomsEvent event, Emitter<RoomState> emit) async {
    emit(RoomLoading());
    try {
      final rooms = await _getListRoomUseCase.getListRoom();
      emit(RoomLoaded(rooms));
    } catch (e) {
      emit(RoomError(e.toString()));
    }
  }
}
