import 'package:flutter/material.dart';
import 'package:mobile_chinese_chess/UI/game_ui.dart';
import 'package:mobile_chinese_chess/client/socket_client.dart';
import 'package:mobile_chinese_chess/client/socket_methods.dart';
import 'package:mobile_chinese_chess/gameInfo/roomInfo.dart';
import 'package:mobile_chinese_chess/gameInfo/userInfo.dart';
import 'package:mobile_chinese_chess/game_manager.dart';
import 'package:mobile_chinese_chess/pages/in_game_page.dart';

class WaitingRoomWidget extends StatefulWidget {
  dynamic data;

  WaitingRoomWidget({required this.data, Key? key}) : super(key: key);

  @override
  State<WaitingRoomWidget> createState() => _WaitingRoomWidgetState();
}

class _WaitingRoomWidgetState extends State<WaitingRoomWidget> {
  RoomInfo roomInfo = RoomInfo();
  bool _chooseRed = true;

  @override
  void initState() {
    print("init waiting room");
    super.initState();
    print("room data is");
    print(widget.data);
    roomInfo.updateInfo(widget.data);
    socketClientCB();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (buildContext, constraints) {
        return Column(
          children: [
            waitingRoomCard(
              constraints: constraints,
              title: "RED",
              playerName:
                  roomInfo.redPlayers.isNotEmpty ? roomInfo.redPlayers[0] : "",
            ),
            waitingRoomCard(
                constraints: constraints,
                title: "BLACK",
                playerName: roomInfo.blackPlayers.isNotEmpty
                    ? roomInfo.blackPlayers[0]
                    : ""),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ElevatedButton(
                        onPressed: leaveRoom, child: const Text("Leave Room")),
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

  Widget waitingRoomCard(
      {required BoxConstraints constraints,
      required String title,
      required String? playerName}) {
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
                        style: const TextStyle(color: Colors.green),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  void leaveRoom() {
    // WebSocketClient.send("leave room");
    Navigator.of(context).pop();
  }

  void socketClientCB() {
    final socket = SocketClient.instance().socket!;

    socket.on("opponentJoined", (data) {
      print("someone joined");
      updateRoomStatus(data);
    });

    socket.on("enterGame", (data) {
      if (roomInfo.playerInRedTeam(UserInfo.username)) {
        GameManager.init(isRedTeam: true);
      } else {
        GameManager.init(isRedTeam: false);
      }
      enterGame();
    });
  }

  void updateRoomStatus(data) {
    setState(() {
      roomInfo.updateInfo(data);
    });
  }

  void enterGame() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return InGamePage(roomInfo: roomInfo);
    }));
  }

  // void streamCB() {
  //   widget.stream.listen((event) {
  //     if (widget.waitingRoom.isTargetListener(jsonDecode(event))) {
  //       setState(() {
  //         widget.waitingRoom.update();
  //       });
  //     }
  //   });
  // }
}
