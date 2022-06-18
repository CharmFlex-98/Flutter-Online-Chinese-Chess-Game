import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_chinese_chess/UI/game_ui.dart';
import 'package:mobile_chinese_chess/client/game_lobby.dart';
import 'package:mobile_chinese_chess/client/waiting_room.dart';
import 'package:mobile_chinese_chess/client/web_socket_client.dart';
import 'package:mobile_chinese_chess/widgets/waiting_room_widget.dart';
import 'package:provider/provider.dart';

class RoomListBox extends StatefulWidget {
  final GameLobby gameLobby;
  final Stream stream;
  const RoomListBox({required this.gameLobby, required this.stream, Key? key})
      : super(key: key);

  @override
  State<RoomListBox> createState() => _RoomListBoxState();
}

class _RoomListBoxState extends State<RoomListBox> {
  final double _cardHeightRatio = 0.08;

  @override
  void initState() {
    streamCB();
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
              itemCount: widget.gameLobby.rooms().length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (BuildContext context, int index) {
                return roomInfoCard(
                    cardHeight: constraints.maxHeight * _cardHeightRatio,
                    owner: widget.gameLobby.rooms()[index].owner,
                    publicRoom: true);
              });
        },
      ),
    );
  }

  Widget roomInfoCard(
      {required String owner,
      required bool publicRoom,
      required double cardHeight}) {
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
                    joinRoom(owner);
                  },
                  child: const Text("JOIN")))
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

  void streamCB() {
    widget.stream.listen((event) {
      dynamic info = jsonDecode(event);
      if (widget.gameLobby.isTargetListener(info)) {
        setState(() {
          widget.gameLobby.update();
        });
      }
    });
  }

  void joinRoom(String owner) {
    showModalBottomSheet(
        context: context,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (context) {
          return WaitingRoomWidget(
            stream: widget.stream,
            waitingRoom: WaitingRoom(key: "roomInfo", owner: owner),
            isOwner: false,
          );
        });
  }
}
