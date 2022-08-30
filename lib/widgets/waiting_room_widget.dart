import 'package:flutter/material.dart';
import 'package:mobile_chinese_chess/UI/game_ui.dart';
import 'package:mobile_chinese_chess/constants.dart';
import 'package:mobile_chinese_chess/client/socket_methods.dart';
import 'package:mobile_chinese_chess/game_manager.dart';
import 'package:mobile_chinese_chess/info/roomInfo.dart';
import 'package:provider/provider.dart';

class WaitingRoomWidget extends StatefulWidget {
  const WaitingRoomWidget({Key? key}) : super(key: key);

  @override
  State<WaitingRoomWidget> createState() => _WaitingRoomWidgetState();
}

class _WaitingRoomWidgetState extends State<WaitingRoomWidget> {
  bool _chooseRed = true;

  @override
  void initState() {
    super.initState();
    SocketMethods methods = SocketMethods();
    methods.roomStatusChangedListener(context);
    methods.leaveRoomSuccessedListener(context);
  }

  @override
  void dispose() {
    SocketMethods().disposeListeners([roomStatusChanged, leaveRoomSuccessed]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RoomInfo roomInfo = Provider.of<RoomInfo>(context);

    // if all players are ready, we need to enter game.
    // start a future method here
    if (roomInfo.roomStatus == RoomStatus.allReady) {
      Future.microtask(() {
        enterGame();
      });
    }
    return LayoutBuilder(
      builder: (buildContext, constraints) {
        return Column(
          children: [
            waitingRoomCard(
                constraints: constraints,
                title: "RED",
                playerName: roomInfo.redPlayers.isNotEmpty
                    ? roomInfo.redPlayers[0]
                    : "",
                playerReady:
                    isReady(roomInfo: roomInfo, isRed: true) ? true : false),
            waitingRoomCard(
                constraints: constraints,
                title: "BLACK",
                playerName: roomInfo.blackPlayers.isNotEmpty
                    ? roomInfo.blackPlayers[0]
                    : "",
                playerReady:
                    isReady(roomInfo: roomInfo, isRed: false) ? true : false),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ElevatedButton(
                        onPressed: () {
                          print("pressed leave");
                          SocketMethods().leaveRoom(roomInfo.roomID!);
                        },
                        child: const Text("Leave Room")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ElevatedButton(
                        onPressed: () {
                          SocketMethods().ready(roomID: roomInfo.roomID!);
                        },
                        child: const Text("Ready")),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }

  bool isReady({required RoomInfo roomInfo, required bool isRed}) {
    if (isRed) {
      return roomInfo.roomStatus == RoomStatus.redReady ||
          roomInfo.roomStatus == RoomStatus.allReady;
    } else {
      return roomInfo.roomStatus == RoomStatus.blackReady ||
          roomInfo.roomStatus == RoomStatus.allReady;
    }
  }

  void enterGame() {
    GameManager.enterGame(context);
  }

  Widget waitingRoomCard(
      {required BoxConstraints constraints,
      required String title,
      required String? playerName,
      required bool playerReady}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (title == "RED") {
            _chooseRed = true;
          } else {
            _chooseRed = false;
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          decoration:
              _chooseRed && title == "RED" || !_chooseRed && title == "BLACK"
                  ? nMboxInvert
                  : nMbox,
          height: constraints.maxHeight * 0.35,
          width: constraints.maxWidth * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                color: title == "RED" ? Colors.red : Colors.black,
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(12),
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              playerName != null
                  ? Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        playerName,
                        style: TextStyle(
                            color: playerReady ? Colors.green : Colors.red),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
