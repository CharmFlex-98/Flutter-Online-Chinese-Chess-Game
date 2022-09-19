import 'package:mobile_chinese_chess/info/info.dart';

class GameStatusInfo extends Info {
  bool endGame = false;
  bool isWinner = false;
  bool restartRequesting = false;
  bool restartInviting = false;
  bool restartGame = false;

  @override
  String keyword() {
    return "";
  }

  @override
  void updateInfo(data) {
    if (data["isWinner"] != null) {
      endGame = true;
      isWinner = data["isWinner"];
    } else if (data["restartRefused"] != null) {
      restartRequesting = false;
      return;
    } else if (data["restartInvited"] != null) {
      restartInviting = true;
    } else if (data["requestCancelled"] != null) {
      restartInviting = false;
    } else if (data["restartGame"] != null) {
      restartGame = true;
    }
  }

  String showStatus() {
    if (restartInviting) {
      return "oppenent request a rematch";
    } else if (restartRequesting) {
      return "waiting for opponent response";
    } else if (endGame) {
      return isWinner ? "You Win!" : "You Lose!";
    }

    return "";
  }

  void resetInfo() {
    endGame = false;
    isWinner = false;
    restartRequesting = false;
    restartInviting = false;
    restartGame = false;
  }
}
