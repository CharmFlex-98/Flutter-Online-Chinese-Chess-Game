import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_chinese_chess/client/constants.dart';
import 'package:mobile_chinese_chess/client/socket_client.dart';
import 'package:mobile_chinese_chess/info/gameStatusInfo.dart';
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

  void endGame(String roomID, bool isWinner) {
    socketClient.emit("endGame", {
      "roomID": roomID,
      "isWinner": isWinner,
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
    print("create room successed");
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
  void roomStatusChangedListener(BuildContext context) {
    print("init listener");
    socketClient.on(roomStatusChanged, (data) {
      print("get data");
      Provider.of<RoomInfo>(context, listen: false).updateInfo(data);
    });
  }
  // void opponentJoinedListener(BuildContext context) {
  //   socketClient.on(
  //       opponentJoined,
  //       (data) =>
  //           {Provider.of<RoomInfo>(context, listen: false).updateInfo(data)});
  // }

  // void opponentLeavedListener(BuildContext context) {
  //   socketClient.on(
  //       opponentLeaved,
  //       (data) =>
  //           {Provider.of<RoomInfo>(context, listen: false).updateInfo(data)});
  // }

  void leaveRoomSuccessedListener(BuildContext context) {
    socketClient.on(leaveRoomSuccessed, (data) => Navigator.of(context).pop());
  }

  void enterGameListener(BuildContext context) {
    socketClient.on(enterGame, (data) async {
      print("enter game");
      RoomInfo roomInfo = Provider.of<RoomInfo>(context, listen: false);
      if (roomInfo.playerInRedTeam(UserInfo.username)) {
        GameManager.init(isRedTeam: true);
      } else {
        GameManager.init(isRedTeam: false);
      }
      await Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const InGamePage();
      }));

      // after pop out from the game mode, need to refresh the waiting room.
      roomInfo.notify();
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

  void gameStatusChangedListener(
      BuildContext context, VoidCallback restartFunc) {
    socketClient.on(gameStatusChanged, (data) {
      // if there is already a dialog opened.
      if (ModalRoute.of(context)?.isCurrent != true) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      print("just at listener start");
      GameStatusInfo info = Provider.of<GameStatusInfo>(context, listen: false);
      info.updateInfo(data);

      // if restart game
      if (info.restartGame) {
        print("begin");
        restartFunc();
        // pop until chess UI route
        while (ModalRoute.of(context)?.isCurrent != true) {
          Navigator.of(context).pop();
        }
        print("after pop");
        info.resetInfo();
        return;
      }

      showDialog(
          context: context,
          builder: (dialogContext) {
            return StatefulBuilder(
              builder: ((dialogContext, setState) {
                GameStatusInfo gameStatusInfo =
                    Provider.of<GameStatusInfo>(context);
                String status = gameStatusInfo.showStatus();
                RoomInfo roomInfo =
                    Provider.of<RoomInfo>(context, listen: false);

                return AlertDialog(
                  content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: status.contains("You")
                          ? [
                              Text(status),
                              TextButton(
                                  onPressed: () {
                                    requestRestart(
                                        gameStatusInfo, roomInfo, setState);
                                  },
                                  child: const Text("Restart")),
                              TextButton(
                                  onPressed: () {
                                    leaveGame(
                                        context, gameStatusInfo, roomInfo);
                                  },
                                  child: const Text("Leave"))
                            ]
                          : status.contains("waiting")
                              ? [
                                  Text(status),
                                  TextButton(
                                      onPressed: () {
                                        cancelRequest(
                                            gameStatusInfo, roomInfo, setState);
                                      },
                                      child: const Text("Cancel"))
                                ]
                              : status.contains("request")
                                  ? [
                                      Text(status),
                                      TextButton(
                                          onPressed: () {
                                            refuseRequest(gameStatusInfo,
                                                roomInfo, setState);
                                          },
                                          child: const Text("Refuse")),
                                      TextButton(
                                          onPressed: () {
                                            acceptRequest(gameStatusInfo,
                                                roomInfo, setState);
                                          },
                                          child: const Text("Accept"))
                                    ]
                                  : []),
                );
              }),
            );
          });
    });
  }

  void opponentLeftGameListener(BuildContext context) {
    socketClient.on(opponentLeftGame, (data) {
      GameStatusInfo info = Provider.of<GameStatusInfo>(context, listen: false);
      RoomInfo roomInfo = Provider.of<RoomInfo>(context, listen: false);
      resetAllStatusAndLeave(context, info, roomInfo);
    });
  }
}

// Game status changed related methods
void requestRestart(
    GameStatusInfo gameStatusInfo, RoomInfo roomInfo, Function setState) {
  final socketClient = SocketClient.instance().socket!;

  socketClient.emit("restartRequested", {"roomID": roomInfo.roomID});
  setState(() {
    gameStatusInfo.restartRequesting = true;
  });
}

void cancelRequest(
    GameStatusInfo gameStatusInfo, RoomInfo roomInfo, Function setState) {
  final socketClient = SocketClient.instance().socket!;

  setState(() {
    gameStatusInfo.restartRequesting = false;
    socketClient.emit("requestCancelled", {"roomID": roomInfo.roomID});
  });
}

void acceptRequest(
    GameStatusInfo gameStatusInfo, RoomInfo roomInfo, Function setState) {
  final socketClient = SocketClient.instance().socket!;

  setState(() {
    gameStatusInfo.restartInviting = false;
    socketClient.emit("restartAccepted", {"roomID": roomInfo.roomID});
  });
}

void refuseRequest(
    GameStatusInfo gameStatusInfo, RoomInfo roomInfo, Function setState) {
  final socketClient = SocketClient.instance().socket!;

  setState(() {
    gameStatusInfo.restartInviting = false;
    socketClient.emit("restartRefused", {"roomID": roomInfo.roomID});
  });
}

void leaveGame(
    BuildContext context, GameStatusInfo gameStatusInfo, RoomInfo roomInfo) {
  final socketClient = SocketClient.instance().socket!;
  socketClient.emit("leaveGame", {"roomID": roomInfo.roomID});

  resetAllStatusAndLeave(context, gameStatusInfo, roomInfo);
}

void resetAllStatusAndLeave(
    BuildContext context, GameStatusInfo gameStatusInfo, RoomInfo roomInfo) {
  gameStatusInfo.resetInfo();
  roomInfo.resetRoomStatus();
  GameManager.reset();

  while (ModalRoute.of(context)?.isCurrent != true) {
    Navigator.of(context).pop();
  }
  Navigator.of(context).pop();

  print("pop end");
}
