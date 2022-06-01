import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketClient {
  static late final IOWebSocketChannel channel;

  static void init() {
    channel = IOWebSocketChannel.connect(Uri.parse('ws://10.0.2.2:8080'));
  }

  static void send(String message) {
    channel.sink.add(message);
    print("messgae send");
  }
}
