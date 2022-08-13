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

    roomID = roomInfo["roomID"].toString();

    redPlayers.clear();
    for (dynamic r in roomInfo["redPlayers"]) {
      redPlayers.add(r["username"] as String);
    }

    blackPlayers.clear();
    for (dynamic b in roomInfo["blackPlayers"]) {
      blackPlayers.add(b["username"] as String);
    }

    notifyListeners();
  }

  bool playerInRedTeam(String username) {
    return redPlayers.contains(username);
  }
}
