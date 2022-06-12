import 'dart:convert';
import 'package:mobile_chinese_chess/client/user.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketClient {
  static late final IOWebSocketChannel _channel;

  // why I feel like this is so ugly
  // they are all listeners whenever receive message from server
  // I think should not store the listener like so hard code
  // lack flexibility...

  static void init() {
    String? user = User.getUserId();
    // should give error message
    if (user == null) return;

    _channel = IOWebSocketChannel.connect(Uri.parse('ws://10.0.2.2:8080'),
        headers: {"username": user});
  }

  static void send(String message) {
    _channel.sink.add(message);
    print("messgae send");
  }

  static IOWebSocketChannel channel() {
    return _channel;
  }
}
