import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_chinese_chess/client/constants.dart';
import 'package:mobile_chinese_chess/client/socket_client.dart';
import 'package:mobile_chinese_chess/info/lobbyInfo.dart';
import 'package:mobile_chinese_chess/info/opponentMoveInfo.dart';
import 'package:mobile_chinese_chess/info/roomInfo.dart';
import 'package:mobile_chinese_chess/info/userInfo.dart';
import 'package:mobile_chinese_chess/game_manager.dart';
import 'package:mobile_chinese_chess/pages/in_game_page.dart';
import 'package:mobile_chinese_chess/pages/lobby_page.dart';
import 'package:provider/provider.dart';

import '../widgets/waiting_room_widget.dart';

class SocketMethods {
  final socketClient = SocketClient.instance().socket!;

  SocketMethods();

  void loginUser(String userName) {
    socketClient.emit("loginUser", {
      "username": userName,
    });
  }

  void createRoom() {
    socketClient.emit("createRoom");
  }

  void joinRoom(String roomID) {
    socketClient.emit("joinRoom", roomID);
  }

  void leaveRoom(String roomID) {
    socketClient.emit("leaveRoom", roomID);
  }

  void ready({required String roomID}) {
    socketClient.emit(
      "ready",
      roomID,
    );
  }

  void move(
      {required String roomID,
      required int prevX,
      required int currX,
      required int prevY,
      required int currY}) {
    socketClient.emit("move", {
      "roomID": roomID,
      "moveData": {
        "prevX": prevX,
        "currX": currX,
        "prevY": prevY,
        "currY": currY,
      }
    });
  }

  // Listener

  // Login page
  void loginSucessedListener(BuildContext context) {
    socketClient.on(loginSuccessed, (data) {
      String username = data["username"];
      Provider.of<LobbyInfo>(context, listen: false).updateInfo(data);
      UserInfo.initUser(username);

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const LobbyPage();
      }));
    });
  }

  // Lobby
  void refreshLobbyListener(BuildContext context) {
    socketClient.on(refreshLobby, (data) {
      Provider.of<LobbyInfo>(context, listen: false).updateInfo(data);
    });
  }

  void createRoomSuccessedListener(BuildContext context) {
    socketClient.on(createRoomSuccessed, (data) {
      Provider.of<RoomInfo>(context, listen: false).updateInfo(data);
      showModalBottomSheet(
          isDismissible: false,
          context: context,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          builder: (context) {
            return const WaitingRoomWidget();
          });
    });
  }

  void joinRoomSuccessedListener(BuildContext context) {
    socketClient.on(joinRoomSuccessed, (data) {
      Provider.of<RoomInfo>(context, listen: false).updateInfo(data);
      showModalBottomSheet(
          context: context,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          builder: (context) {
            return const WaitingRoomWidget();
          });
    });
  }

  void joinRoomErrorListener() {
    socketClient.on(joinRoomError, (_) {
      Fluttertoast.showToast(msg: "Could not join room!");
    });
  }

  void createRoomErrorListener() {
    socketClient.on(
        createRoomError,
        (data) => Fluttertoast.showToast(
            msg: "Failed to create room! Check your internet connection!"));
  }

  void disposeListeners(List<String> listeners) {
    for (String listener in listeners) {
      socketClient.off(listener);
    }
  }

  // Waiting Room
  void opponentJoinedListener(BuildContext context) {
    socketClient.on(
        opponentJoined,
        (data) =>
            {Provider.of<RoomInfo>(context, listen: false).updateInfo(data)});
  }

  void opponentLeavedListener(BuildContext context) {
    socketClient.on(
        opponentLeaved,
        (data) =>
            {Provider.of<RoomInfo>(context, listen: false).updateInfo(data)});
  }

  void leaveRoomSuccessedListener(BuildContext context) {
    socketClient.on(leaveRoomSuccessed, (data) => Navigator.of(context).pop());
  }

  void enterGameListener(BuildContext context) {
    socketClient.on(enterGame, (data) {
      print("enter game");
      RoomInfo roomInfo = Provider.of<RoomInfo>(context, listen: false);
      if (roomInfo.playerInRedTeam(UserInfo.username)) {
        GameManager.init(isRedTeam: true);
      } else {
        GameManager.init(isRedTeam: false);
      }
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const InGamePage();
      }));
    });
  }

  // In game
  void playerMoveListener(BuildContext context, Function opponentMoveCB) {
    socketClient.on(playerMove, (data) {
      OpponentMoveInfo moveInfo = OpponentMoveInfo();
      moveInfo.updateInfo(data);

      opponentMoveCB(moveInfo);
    });
  }
}
