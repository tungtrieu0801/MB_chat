import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_trip_togethor/core/shared/usecases/clear_cache_user_usecase.dart';
import 'package:mobile_trip_togethor/features/setting/presentation/bloc/setting_event.dart';
import 'package:mobile_trip_togethor/features/setting/presentation/bloc/setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final ClearCacheUserUseCase clearCacheUserUseCase;
  SettingBloc(this.clearCacheUserUseCase) :super(SettingInitial()) {
    on<LogoutEvent>((event, emit) async {
      emit(SettingLoading());
      try {
        await clearCacheUserUseCase.clearCacheUser();
        emit(SettingSuccess());
      } catch (e) {
        emit(SettingError(e.toString()));
        print('fail to login');
      }
    });
  }
}