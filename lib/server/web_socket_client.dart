import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class WebSocketClient {
  static late final IOWebSocketChannel channel;

  static void init() {
    channel = IOWebSocketChannel.connect(Uri.parse('ws://localhost:8080'));
  }

  static void send(String message) {
    channel.stream.listen((message) {
      channel.sink.add('received!');
      channel.sink.close(status.goingAway);
    });
  }
}
