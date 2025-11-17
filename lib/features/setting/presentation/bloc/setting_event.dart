import 'package:equatable/equatable.dart';
import 'package:mobile_trip_togethor/features/auth/presentation/bloc/auth_event.dart';

abstract class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object?> get props => [];
}

class LogoutEvent extends SettingEvent {
  @override
  List<Object?> get props => [];
}
