import 'package:equatable/equatable.dart';
import 'package:mobile_trip_togethor/features/chat/domain/entities/room.dart';

abstract class RoomState extends Equatable {
  const RoomState();

  @override
  List<Object?> get props => [];
}

class RoomInitial extends RoomState {}

class RoomLoading extends RoomState {}

class RoomLoaded extends RoomState {
  final List<Room> rooms;

  const RoomLoaded(this.rooms);

  @override
  List<Object?> get props => [rooms];
}

class RoomError extends RoomState {
  final String message;

  const RoomError(this.message);

  @override
  List<Object?> get props => [message];
}

class Message {
  final String id;
  final String content;
  final String roomId;
  final String senderId;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.content,
    required this.roomId,
    required this.senderId,
    required this.createdAt,
  });
}


