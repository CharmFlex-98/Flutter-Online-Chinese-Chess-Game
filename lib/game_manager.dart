import 'package:flutter/material.dart';
import 'package:mobile_chinese_chess/client/socket_client.dart';
import 'package:mobile_chinese_chess/constants.dart';
import 'package:mobile_chinese_chess/info/game_status_info.dart';
import 'package:mobile_chinese_chess/info/room_info.dart';
import 'package:mobile_chinese_chess/info/user_info.dart';
import 'package:mobile_chinese_chess/utilities.dart';
import 'package:provider/provider.dart';

// This class is a singleton
class GameManager {
  static GameManager? _instance;
  late bool _isRedTurn;
  late bool _win;
  late bool _isRedTeam;
  bool _gameEnd = false;

  GameManager instance() {
    _instance ??= this;

    return _instance!;
  }

  void init({bool isRedTeam = true}) {
    _isRedTurn = true;
    setTeam(isRedTeam: isRedTeam);
  }

  void changeTurn() {
    _isRedTurn = !_isRedTurn;
  }

  setRedTurn() {
    _isRedTurn = true;
  }

  bool isRedTurn() {
    return _isRedTurn;
  }

  setBlackTurn() {
    _isRedTurn = false;
  }

  Point boardPointConvert(Point pointFrom) {
    int x = boardPointXConvert(pointFrom.x);
    int y = boardPointYConvert(pointFrom.y);

    return Point(x, y);
  }

  int boardPointXConvert(int pointX) {
    return 8 - pointX;
  }

  int boardPointYConvert(int pointY) {
    return 9 - pointY;
  }

  bool win() {
    return _win;
  }

  bool isRedTeam() {
    return _isRedTeam;
  }

  void setTeam({bool isRedTeam = true}) {
    _isRedTeam = isRedTeam;
  }

  void endGame({bool redWin = true}) {
    _gameEnd = true;
    _win = redWin && isRedTeam() ? true : false;
  }

  bool gameIsEnd() {
    return _gameEnd;
  }

  void restartGame() {
    reset();
  }

  void reset() {
    _gameEnd = false;
    _isRedTurn = true;
    _win = false;
  }

  void enterGame(BuildContext context) async {
    RoomInfo roomInfo = Provider.of<RoomInfo>(context, listen: false);
    if (roomInfo.playerInRedTeam(UserInfo.username)) {
      init(isRedTeam: true);
    } else {
      init(isRedTeam: false);
    }
    await Navigator.pushNamed(context, inGamePage);

    // after pop out from the game mode, need to refresh the waiting room.
    roomInfo.notify();
  }

  void leaveGame(BuildContext context) {
    GameStatusInfo gameStatusInfo =
        Provider.of<GameStatusInfo>(context, listen: false);
    RoomInfo roomInfo = Provider.of<RoomInfo>(context, listen: false);

    final socketClient = SocketClient.instance().socket!;
    socketClient.emit("leaveGame", {"roomID": roomInfo.roomID});

    resetAllStatusAndLeave(context, gameStatusInfo, roomInfo);
  }

  void resetAllStatusAndLeave(
      BuildContext context, GameStatusInfo gameStatusInfo, RoomInfo roomInfo) {
    gameStatusInfo.resetInfo();
    roomInfo.resetRoomStatus();
    GameManager().instance().reset();

    Navigator.of(context).popUntil(ModalRoute.withName(inGamePage));
    Navigator.of(context).pop();
  }
}
