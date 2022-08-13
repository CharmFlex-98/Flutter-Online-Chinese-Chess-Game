import 'package:mobile_chinese_chess/game_manager.dart';
import 'package:mobile_chinese_chess/utilities.dart';

class OpponentMoveInfo {
  Point? prevPoint;
  Point? currPoint;

  @override
  String keyword() {
    return "moveInfo";
  }

  @override
  void updateInfo(data) {
    data = data[keyword()];

    prevPoint = GameManager.boardPointConvert(Point(
      data["prevX"],
      data["prevY"],
    ));
    currPoint = GameManager.boardPointConvert(Point(
      data["currX"],
      data["currY"],
    ));
  }
}
