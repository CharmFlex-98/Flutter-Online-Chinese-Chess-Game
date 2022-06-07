import 'package:flutter/material.dart';
import 'package:mobile_chinese_chess/UI/game_ui.dart';
import 'package:mobile_chinese_chess/client/waiting_room.dart';
import 'package:mobile_chinese_chess/client/web_socket_client.dart';
import 'package:provider/provider.dart';

class WaitingRoomWidget extends StatefulWidget {
  const WaitingRoomWidget({Key? key}) : super(key: key);

  @override
  State<WaitingRoomWidget> createState() => _WaitingRoomWidgetState();
}

class _WaitingRoomWidgetState extends State<WaitingRoomWidget> {
  bool _chooseRed = true;
  @override
  Widget build(BuildContext context) {
    WaitingRoom waitingRoom = Provider.of<WaitingRoom>(context);

    return LayoutBuilder(
      builder: (buildContext, constraints) {
        return Column(
          children: [
            waitingRoomCard(
                constraints: constraints,
                title: "RED",
                playerName: waitingRoom.redTeam.isEmpty
                    ? null
                    : waitingRoom.redTeam[0]),
            waitingRoomCard(
                constraints: constraints,
                title: "BLACK",
                playerName: waitingRoom.blackTeam.isEmpty
                    ? null
                    : waitingRoom.blackTeam[0]),
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
                        onPressed: () {}, child: const Text("Ready")),
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
    WebSocketClient.send("leave room");
    Navigator.of(context).pop();
  }
}
