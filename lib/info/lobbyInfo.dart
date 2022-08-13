import 'info.dart';

class LobbyInfo extends Info {
  List<dynamic> _roomInfos = [];

  @override
  void updateInfo(data) {
    _roomInfos = data[keyword()];
    notifyListeners();
  }

  List<dynamic> getRoomInfos() {
    return [..._roomInfos];
  }

  @override
  String keyword() {
    return "lobbyInfo";
  }
}
