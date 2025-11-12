// features/chat/data/datasources/socket_remote_datasource.dart
import 'dart:async';
import '../../../../core/network/socket_manager.dart';

abstract class SocketRemoteDataSource {
  Future<void> connect();
  Future<void> joinRoom(String roomId);
  // Future<void> sendMessage(String roomId, Map<String, dynamic> payload);
  Stream<dynamic> onMessageReceived();
  void dispose();
}

class SocketRemoteDataSourceImpl implements SocketRemoteDataSource {
  final SocketManager _socketManager;

  SocketRemoteDataSourceImpl(this._socketManager);

  @override
  Future<void> connect() async {
    // khởi tạo và connect
    _socketManager.initAndConnect(); // path mặc định '/chat'
    // optional: await until connected if needed
  }

  @override
  Future<void> joinRoom(String roomId) async {
    await _socketManager.joinRoom(roomId);
  }

  // @override
  // Future<void> sendMessage(String roomId, Map<String, dynamic> payload) async {
  //   // dùng event name giống server: 'send_message'
  //   _socketManager.emit('send_message', {
  //     'roomId': roomId,
  //     ...payload,
  //   });
  // }

  @override
  Stream<dynamic> onMessageReceived() {
    // server gửi 'message_received' theo NestJS bạn dùng trước đó
    return _socketManager.on('message_received');
  }

  @override
  void dispose() {
    // nếu datasource không dùng nữa
    _socketManager.off('message_received');
  }
}
