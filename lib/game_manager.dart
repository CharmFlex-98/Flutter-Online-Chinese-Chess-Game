import 'package:mobile_chinese_chess/utilities.dart';

class GameManager {
  static late bool _isRedTurn;
  static late bool _redWin;
  static late bool _isRedTeam;
  static bool _gameEnd = false;

  static void init() {
    _isRedTurn = true;
    setTeam(false);
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

  static void setWinner(bool redWin) {
    _redWin = redWin;
  }

  static bool isRedTeam() {
    return _isRedTeam;
  }

  static void setTeam(bool isRedTeam) {
    _isRedTeam = isRedTeam;
  }

  static void endGame() {
    _gameEnd = true;
  }

  static bool gameIsEnd() {
    return _gameEnd;
  }
}
