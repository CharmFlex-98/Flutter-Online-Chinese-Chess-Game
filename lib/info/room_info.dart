import 'package:mobile_chinese_chess/info/info.dart';

enum RoomStatus {
  allNotReady,
  redReady,
  blackReady,
  allReady,
}

class RoomInfo extends Info {
  String? roomID;
  List<String> redPlayers = [];
  List<String> blackPlayers = [];
  RoomStatus roomStatus = RoomStatus.allNotReady;

  @override
  String keyword() {
    return "roomInfo";
  }

  @override
  void updateInfo(data) {
    dynamic roomInfo = data[keyword()];

    _setRoomID(roomInfo);
    _setRedPlayers(roomInfo);
    _setBlackPlayers(roomInfo);
    _setRoomStatus(roomInfo);

    notifyListeners();
  }

  bool playerInRedTeam(String username) {
    return redPlayers.contains(username);
  }

  void _setRoomID(dynamic roomInfo) {
    roomID = roomInfo["roomID"].toString();
  }

  void _setRedPlayers(dynamic roomInfo) {
    redPlayers.clear();
    for (dynamic r in roomInfo["redPlayers"]) {
      redPlayers.add(r["username"] as String);
    }
  }

  void _setBlackPlayers(dynamic roomInfo) {
    blackPlayers.clear();
    for (dynamic b in roomInfo["blackPlayers"]) {
      blackPlayers.add(b["username"] as String);
    }
  }

  void _setRoomStatus(dynamic roomInfo) {
    int index = roomInfo["roomStatus"];
    if (index == 0) {
      roomStatus = RoomStatus.allNotReady;
    } else if (index == 1) {
      roomStatus = RoomStatus.redReady;
    } else if (index == 2) {
      roomStatus = RoomStatus.blackReady;
    } else if (index == 3) {
      roomStatus = RoomStatus.allReady;
    }
  }

  void resetRoomStatus() {
    roomStatus = RoomStatus.allNotReady;
  }
}
