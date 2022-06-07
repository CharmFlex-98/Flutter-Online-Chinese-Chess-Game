import 'dart:convert';
import 'package:mobile_chinese_chess/client/gameChangeNotifier.dart';
import 'package:mobile_chinese_chess/client/user.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketClient {
  static late final IOWebSocketChannel _channel;

  // why I feel like this is so ugly
  // they are all listeners whenever receive message from server
  // I think should not store the listener like so hard code
  // lack flexibility...
  static late final List<GameChangeNotifier> listeners = [];

  static void init() {
    String? user = User.getUserId();
    // should give error message
    if (user == null) return;

    _channel = IOWebSocketChannel.connect(Uri.parse('ws://10.0.2.2:8080'),
        headers: {"username": user});
    _channel.stream.listen((message) {
      dynamic info = jsonDecode(message);

      for (GameChangeNotifier listener in listeners) {
        if (listener.isTargetListener(receivedInfo: info)) {
          listener.update();
          break;
        }
      }
    });
  }

  static void send(String message) {
    _channel.sink.add(message);
    print("messgae send");
  }

  static void addListener(GameChangeNotifier listener) {
    listeners.add(listener);
  }

  static void removeListener(GameChangeNotifier listener) {
    listeners.remove(listener);
  }
}
