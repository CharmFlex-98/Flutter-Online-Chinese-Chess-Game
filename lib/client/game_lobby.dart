import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_chinese_chess/client/stream_listener.dart';
import 'package:mobile_chinese_chess/client/web_socket_client.dart';

import 'room.dart';

class GameLobby extends StreamListener {
  GameLobby({required String key}) : super(key);

  final List<Room> _rooms = [];

  void insertRoom(Room room) {
    _rooms.add(room);
  }

  void deleteRoom(Room room) {
    _rooms.remove(room);
  }

  List<Room> rooms() {
    return _rooms;
  }

  @override
  List<Map<String, dynamic>> preManipulation(receivedStream) {
    dynamic info = receivedStream[key];

    return List<Map<String, dynamic>>.from(info).toList();
  }

  @override
  void update() {
    print("update in gamelobby");
    print(data());
    _rooms.clear();
    for (dynamic roomInfo in data()) {
      _rooms.add(Room(
          id: roomInfo["roomId"],
          owner: roomInfo["owner"],
          players: [...roomInfo["redPlayers"], ...roomInfo["blackPlayers"]]));
    }

    for (Room room in _rooms) {
      print("blackPlayer : ${room.players}");
    }
  }

  @override
  dynamic extractRealInfo(receivedStream) {
    return receivedStream[key];
  }
}
