import 'package:mobile_chinese_chess/game_manager.dart';
import 'package:mobile_chinese_chess/info/info.dart';
import 'package:mobile_chinese_chess/utilities.dart';

class OpponentMoveInfo extends Info {
  Point? prevPoint;
  Point? currPoint;

  @override
  String keyword() {
    return "moveInfo";
  }

  @override
  void updateInfo(data) {
    data = data[keyword()];

    prevPoint = GameManager().instance().boardPointConvert(Point(
          data["prevX"],
          data["prevY"],
        ));
    currPoint = GameManager().instance().boardPointConvert(Point(
          data["currX"],
          data["currY"],
        ));
  }
}
