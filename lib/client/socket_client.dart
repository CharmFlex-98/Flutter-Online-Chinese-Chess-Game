import "package:socket_io_client/socket_io_client.dart" as io;

// singleton class, only 1 socket per player
class SocketClient {
  io.Socket? socket;
  static SocketClient? _instance;

  SocketClient._() {
    socket = io.io('http://192.168.100.17:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket!.connect();
  }

  static SocketClient instance() {
    _instance ??= SocketClient._();

    return _instance!;
  }
}
