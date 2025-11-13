// features/chat/data/datasources/socket_remote_datasource.dart
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/network/socket_manager.dart';
import '../../../../core/shared/usecases/get_cache_user_usecase.dart';

abstract class SocketRemoteDataSource {
  Future<void> connect();
  Future<void> joinRoom(String roomId);
  // Future<void> sendMessage(String roomId, Map<String, dynamic> payload);
  Stream<dynamic> onMessageReceived();
  void dispose();
}

class SocketRemoteDataSourceImpl implements SocketRemoteDataSource {
  final SocketManager _socketManager;
  final GetCacheUserUseCase getCacheUserUseCase;
  SocketRemoteDataSourceImpl(this._socketManager, this.getCacheUserUseCase);

  @override
  Future<void> connect() async {
    final result = await getCacheUserUseCase.call();
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
