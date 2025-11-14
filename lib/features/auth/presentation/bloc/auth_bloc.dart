import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_trip_togethor/core/network/socket_manager.dart';
import '../../domain/usecases/login_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final SocketManager socketManager;

  AuthBloc(this.loginUsecase, this.socketManager) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await loginUsecase(event.username, event.password);
        print('Logged in user: ${user.username}');
        emit(AuthSuccess(user));

        // Connect socket
        socketManager.initAndConnect(userId: user.id);
        print('Socket connecting with userId: ${user.id}');
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
