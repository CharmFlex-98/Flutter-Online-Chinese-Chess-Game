import 'package:flutter/material.dart';
import 'package:mobile_chinese_chess/constants.dart';
import 'package:mobile_chinese_chess/info/roomInfo.dart';
import 'package:mobile_chinese_chess/info/userInfo.dart';
import 'package:mobile_chinese_chess/utilities.dart';
import 'package:provider/provider.dart';

class GameManager {
  static late bool _isRedTurn;
  static late bool _win;
  static late bool _isRedTeam;
  static bool _gameEnd = false;

  static void init({bool isRedTeam = true}) {
    _isRedTurn = true;
    setTeam(isRedTeam: isRedTeam);
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

  static Point boardPointConvert(Point pointFrom) {
    int x = boardPointXConvert(pointFrom.x);
    int y = boardPointYConvert(pointFrom.y);

    return Point(x, y);
  }

  static int boardPointXConvert(int pointX) {
    return 8 - pointX;
  }

  static int boardPointYConvert(int pointY) {
    return 9 - pointY;
  }

  static bool win() {
    return _win;
  }

  static bool isRedTeam() {
    return _isRedTeam;
  }

  static void setTeam({bool isRedTeam = true}) {
    _isRedTeam = isRedTeam;
  }

  static void endGame({bool redWin = true}) {
    _gameEnd = true;
    _win = redWin && isRedTeam() ? true : false;
    print(_win);
  }

  static bool gameIsEnd() {
    return _gameEnd;
  }

  static void restartGame() {
    reset();
  }

  static void reset() {
    _gameEnd = false;
    _isRedTurn = true;
    _win = false;
  }

  static void enterGame(BuildContext context) async {
    RoomInfo roomInfo = Provider.of<RoomInfo>(context, listen: false);
    if (roomInfo.playerInRedTeam(UserInfo.username)) {
      GameManager.init(isRedTeam: true);
    } else {
      GameManager.init(isRedTeam: false);
    }
    await Navigator.pushNamed(context, inGamePage);

    // after pop out from the game mode, need to refresh the waiting room.
    roomInfo.notify();
  }
}
