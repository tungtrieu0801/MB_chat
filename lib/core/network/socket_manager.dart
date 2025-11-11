// core/network/socket_manager.dart
import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../constants/api_endpoint.dart';

class SocketManager {
  static final SocketManager _instance = SocketManager._internal();
  factory SocketManager() => _instance;

  IO.Socket? _socket;
  final Map<String, StreamController<dynamic>> _controllers = {};
  final Set<String> _joinedRooms = {};
  bool _isConnecting = false;

  SocketManager._internal();

  bool get isConnected => _socket?.connected == true;

  void initAndConnect({String? namespacePath}) {
    // Nếu đã có socket và connected thì thôi
    if (_socket != null && _socket!.connected) return;
    if (_isConnecting) return;

    _isConnecting = true;

    _socket = IO.io(
      ApiEndpoint.socketUrl, // ví dụ: http://192.168.173.209:3000
      IO.OptionBuilder()
          // .setPath(namespacePath ?? '/chat') // namespace / path nếu cần
          .setTransports(['websocket', 'polling'])
          .enableAutoConnect() // auto connect khi tạo
          .enableReconnection() // bật reconnect tự động
          .build(),
    );

    // Các listener cơ bản (một lần)
    _socket!
      ..onConnect((_) {
        _isConnecting = false;
        print('SocketManager: connected (${_socket!.id})');
        // rejoin các room đã join trước đó
        for (final r in _joinedRooms) {
          _socket!.emit('join_room', {'roomId': r});
        }
      })
      ..onDisconnect((_) {
        print('SocketManager: disconnected');
      })
      ..onConnectError((err) => print('SocketManager: connect error: $err'))
      ..onError((err) => print('SocketManager: error: $err'));

    // đợi kết nối xong (option)
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
    _isConnecting = false;
    // đóng các controllers
    for (final c in _controllers.values) {
      c.close();
    }
    _controllers.clear();
    _joinedRooms.clear();
  }

  void emit(String event, dynamic data) {
    if (_socket?.connected == true) {
      _socket!.emit(event, data);
    } else {
      print('SocketManager.emit: not connected -> $event');
    }
  }

  Future<dynamic> emitWithAck(String event, dynamic data, {Duration timeout = const Duration(seconds: 5)}) {
    final completer = Completer<dynamic>();
    if (_socket?.connected == true) {
      try {
        _socket!.emitWithAck(event, data, ack: (response) {
          if (!completer.isCompleted) completer.complete(response);
        });
        // timeout
        Future.delayed(timeout, () {
          if (!completer.isCompleted) completer.completeError('emitWithAck timeout');
        });
      } catch (e) {
        if (!completer.isCompleted) completer.completeError(e);
      }
    } else {
      completer.completeError('Socket not connected');
    }
    return completer.future;
  }

  /// Trả về stream cho event; tạo StreamController nếu chưa có
  Stream<dynamic> on(String eventName) {
    if (_controllers.containsKey(eventName)) {
      return _controllers[eventName]!.stream;
    }

    final controller = StreamController<dynamic>.broadcast(onCancel: () {
      // nếu ko còn listener nào, ta vẫn giữ controller để reuse (tuỳ chọn)
    });

    _controllers[eventName] = controller;
    _socket?.on(eventName, (data) {
      if (!controller.isClosed) controller.add(data);
    });

    return controller.stream;
  }

  /// Hủy lắng nghe event ở phía client (xóa controller)
  void off(String eventName) {
    _socket?.off(eventName);
    final c = _controllers.remove(eventName);
    c?.close();
  }

  /// Join room và lưu vào set _joinedRooms để rejoin khi reconnect
  Future<void> joinRoom(String roomId) async {
    try {
      final resp = await emitWithAck('join_room', {'roomId': roomId});
      // server có thể trả { success: true }
      if (resp != null && resp['success'] == true) {
        _joinedRooms.add(roomId);
      } else {
        // nếu server trả khác thì vẫn add tuỳ logic bạn muốn
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Leave room
  void leaveRoom(String roomId) {
    _socket?.emit('leave_room', {'roomId': roomId});
    _joinedRooms.remove(roomId);
  }
}
