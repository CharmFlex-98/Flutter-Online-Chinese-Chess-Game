import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_chinese_chess/client/gameChangeNotifier.dart';
import 'package:mobile_chinese_chess/client/web_socket_client.dart';

import 'room.dart';

class GameLobby extends GameChangeNotifier {
  GameLobby({required String key}) : super(key) {
    WebSocketClient.addListener(this);
  }
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

  void _updateRoomList() {
    _rooms.clear();
    for (dynamic room in getReceivedInfo()) {
      _rooms.add(Room(room["roomId"], room["owner"]["id"],
          [...room["redPlayers"], ...room["blackPlayers"]]));
    }
  }

  void _notify() {
    notifyListeners();
    _newJoinerNotification();
  }

  void _newJoinerNotification() {
    Fluttertoast.cancel();
    Fluttertoast.showToast(msg: "new player joined!");
  }

  @override
  bool update() {
    print("update");
    _updateRoomList();
    _notify();
    return true;
  }

  @override
  bool isTargetListener({required dynamic receivedInfo}) {
    print(receivedInfo);
    super.isTargetListener(receivedInfo: receivedInfo);

    return getReceivedInfo() != null;
  }
}
