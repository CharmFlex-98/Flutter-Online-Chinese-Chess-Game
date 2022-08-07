import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_chinese_chess/UI/game_ui.dart';
import 'package:mobile_chinese_chess/client/socket_client.dart';
import 'package:mobile_chinese_chess/client/socket_methods.dart';

import '../../gameInfo/lobbyInfo.dart';
import '../waiting_room_widget.dart';

class RoomListBox extends StatefulWidget {
  LobbyInfo lobbyInfo;
  RoomListBox({required this.lobbyInfo, Key? key}) : super(key: key);

  @override
  State<RoomListBox> createState() => _RoomListBoxState();
}

class _RoomListBoxState extends State<RoomListBox> {
  final double _cardHeightRatio = 0.08;

  @override
  void initState() {
    socketListenerCB();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: nMboxInvert,
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ListView.builder(
              itemCount: widget.lobbyInfo.getRoomInfos().length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (BuildContext context, int index) {
                return roomInfoCard(
                    roomID: widget.lobbyInfo
                        .getRoomInfos()[index]["roomID"]
                        .toString(),
                    cardHeight: constraints.maxHeight * _cardHeightRatio,
                    owner: widget.lobbyInfo.getRoomInfos()[index]["owner"]
                        ["username"],
                    publicRoom: true,
                    isFull: roomIsFull(widget.lobbyInfo.getRoomInfos()[index]));
              });
        },
      ),
    );
  }

  Widget roomInfoCard(
      {required String owner,
      required String roomID,
      required bool publicRoom,
      required double cardHeight,
      required bool isFull}) {
    return Container(
      height: cardHeight,
      width: double.infinity,
      decoration: nMbox,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                label("Owner", Colors.orange),
                Padding(
                    padding: const EdgeInsets.only(right: 3, top: 3, bottom: 3),
                    child: Text(owner)),
              ],
            ),
          ),
          label(publicRoom ? "PUBLIC" : "PRIVATE",
              publicRoom ? Colors.green : Colors.red[700]),
          Padding(
              padding: const EdgeInsets.all(3),
              child: TextButton(
                  onPressed: () {
                    if (!isFull) SocketMethods().joinRoom(roomID);
                  },
                  child: isFull ? const Text("FULL") : const Text("JOIN")))
        ],
      ),
    );
  }

  Widget label(String text, Color? color) {
    return Container(
        color: color,
        padding: const EdgeInsets.all(3),
        margin: const EdgeInsets.only(left: 12, right: 12),
        child: Text(text));
  }

  bool roomIsFull(dynamic roomInfo) {
    return roomInfo["redPlayers"].length + roomInfo["blackPlayers"].length >= 2;
  }

  void socketListenerCB() {
    final socket = SocketClient.instance().socket!;

    socket.on("joinRoomSuccessed", (data) {
      joinRoom(data);
    });

    socket.on("error", (_) {
      Fluttertoast.showToast(msg: "Error! Could not join the room!");
    });
  }

  void joinRoom(data) {
    print(data);
    dynamic roomInfo = data["roomInfo"];
    showModalBottomSheet(
        context: context,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (context) {
          return WaitingRoomWidget(
            data: data,
          );
        });
  }
}
