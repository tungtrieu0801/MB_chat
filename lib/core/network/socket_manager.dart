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

  void initAndConnect({required String userId}) {
    if (_socket != null && _socket!.connected) return;
    if (_isConnecting) return;

    _isConnecting = true;

    _socket = IO.io(
      ApiEndpoint.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .enableAutoConnect()
          .enableReconnection()
          .setQuery({ 'userId': userId })
          .build(),
    );

    _socket!
      ..onConnect((_) {
        _isConnecting = false;
        print('SocketManager: connected (${_socket!.id})');
        for (final r in _joinedRooms) {
          _socket!.emit('room:join', {'roomId': r});
        }
      })
      ..onDisconnect((_) => print('SocketManager: disconnected'))
      ..onConnectError((err) => print('SocketManager: connect error: $err'))
      ..onError((err) => print('SocketManager: error: $err'));
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
    _isConnecting = false;
    for (final c in _controllers.values) c.close();
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

  Future<dynamic> emitWithAck(String event, dynamic data,
      {Duration timeout = const Duration(seconds: 5)}) {
    final completer = Completer<dynamic>();
    if (_socket?.connected == true) {
      try {
        _socket!.emitWithAck(event, data, ack: (response) {
          if (!completer.isCompleted) completer.complete(response);
        });
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

  Stream<dynamic> on(String eventName) {
    if (_controllers.containsKey(eventName)) return _controllers[eventName]!.stream;

    final controller = StreamController<dynamic>.broadcast();
    _controllers[eventName] = controller;

    _socket?.on(eventName, (data) {
      if (!controller.isClosed) controller.add(data);
    });

    return controller.stream;
  }

  void off(String eventName) {
    _socket?.off(eventName);
    final c = _controllers.remove(eventName);
    c?.close();
  }

  /// --- Join room ---
  Future<void> joinRoom(String roomId) async {
    if (_socket?.connected == true) {
      _socket!.emit('room:join', {'roomId': roomId});
      _joinedRooms.add(roomId);
      print('SocketManager: joined room $roomId');
    } else {
      print('SocketManager: cannot join room, socket not connected');
    }
  }

  /// --- Leave room ---
  void leaveRoom(String roomId) {
    _socket?.emit('room:leave', {'roomId': roomId});
    _joinedRooms.remove(roomId);
  }

  void sendMessage(String roomId, Map<String, dynamic> message) {
    emit('message:send', message); // <-- gửi event SEND
  }

  /// --- Lắng nghe message của 1 room ---
  /// server phát lại cho room -> SOCKET_EVENTS.MESSAGE.RECEIVE
  Stream<dynamic> onMessage(String roomId) {
    return on('message:receive') // <-- lắng nghe event RECEIVE
        .where((data) => data['roomId'] == roomId);
  }
  
  void reactMessage(String roomId, Map<String, dynamic> data) {
    emit('message:react', data);
  }

  Stream<dynamic> onMessageReactedStream(String roomId) {
    return on('message:reacted').where((data) => data['roomId'] == roomId);
  }

  Stream<dynamic> onMessageStream() {
    return on('message:receive');
  }

  void sendTyping(String roomId, String userId, bool isTyping) {
    emit('message:typing', {'roomId': roomId, 'userId': userId, 'isTyping': isTyping});
  }

  Stream<dynamic> onTyping(String roomId) {
    return on('message:typing').where((data) => data['roomId'] == roomId);
  }

  /// Call signaling
  void sendCallOffer(String toUserId, dynamic sdp) {
    emit('call:offer', {'toUserId': toUserId, 'sdp': sdp});
  }

  Stream<dynamic> onCallOffer() {
    return on('call:offer');
  }

  void sendCallAnswer(String toUserId, dynamic sdp) {
    emit('call:answer', {'toUserId': toUserId, 'sdp': sdp});
  }

  Stream<dynamic> onCallAnswer() {
    return on('call:answer');
  }

  void sendCallIce(String toUserId, dynamic candidate) {
    emit('call:ice', {'toUserId': toUserId, 'candidate': candidate});
  }

  Stream<dynamic> onCallIce() {
    return on('call:ice');
  }

  void sendCallHangup(String toUserId) {
    emit('call:hangup', {'toUserId': toUserId});
  }

  Stream<dynamic> onCallHangup() {
    return on('call:hangup');
  }

}
