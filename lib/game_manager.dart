import 'package:mobile_chinese_chess/utilities.dart';

class GameManager {
  static late bool _isRedTurn;

  static void init() {
    _isRedTurn = true;
  }

  static void changeTurn() {
    _isRedTurn = !_isRedTurn;
  }

  static setRedTurn() {
    _isRedTurn = true;
  }

  static bool isRedTurn() {
    return _isRedTurn;
  }

  static setBlackTurn() {
    _isRedTurn = false;
  }

  static Point? boardPointConvert() {
    return null;
  }
}
