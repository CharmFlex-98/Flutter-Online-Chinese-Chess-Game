import 'package:mobile_chinese_chess/client/stream_listener.dart';
import 'package:mobile_chinese_chess/client/user.dart';
import 'package:mobile_chinese_chess/client/web_socket_client.dart';

class WaitingRoom extends StreamListener {
  String owner;
  List<String> redPlayers = [];
  List<String> blackPlayers = [];

  WaitingRoom({required String key, required this.owner}) : super(key) {
    redPlayers.add(owner);
  }

  void destroyRoom() {
    redPlayers.clear();
    blackPlayers.clear();
    redPlayers.add(owner);
  }

  @override
  void update() {
    print("update in waiting room");
    print(data());
    owner = data()["owner"];
    redPlayers = List<String>.from(data()["redPlayers"]).toList();
    blackPlayers = List<String>.from(data()["blackPlayers"]).toList();
    print("red team : $redPlayers   blackTeam : $blackPlayers");
  }

  @override
  dynamic extractRealInfo(receivedStream) {
    return receivedStream[key];
  }
}
