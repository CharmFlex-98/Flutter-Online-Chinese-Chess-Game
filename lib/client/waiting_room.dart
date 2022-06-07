import 'package:mobile_chinese_chess/client/gameChangeNotifier.dart';
import 'package:mobile_chinese_chess/client/user.dart';
import 'package:mobile_chinese_chess/client/web_socket_client.dart';

class WaitingRoom extends GameChangeNotifier {
  String owner;
  List<String> redTeam = [];
  List<String> blackTeam = [];

  WaitingRoom({required String key, required this.owner}) : super(key) {
    WebSocketClient.addListener(this);
    redTeam.add(owner);
  }

  @override
  bool update() {
    _updateTeamSelection();
    notifyListeners();
    return true;
  }

  @override
  bool isTargetListener({dynamic receivedInfo}) {
    super.isTargetListener(receivedInfo: receivedInfo);

    return getReceivedInfo() != null;
  }

  void _updateTeamSelection() {
    redTeam = getReceivedInfo()[0]["redPlayers"];
    blackTeam = getReceivedInfo()[0]["blackPlayers"];
  }

  void destroyRoom() {
    redTeam.clear();
    blackTeam.clear();
    redTeam.add(owner);
  }
}
