import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_chinese_chess/UI/game_ui.dart';
import 'package:mobile_chinese_chess/client/game_lobby.dart';
import 'package:provider/provider.dart';

class LobbyListBox extends StatefulWidget {
  const LobbyListBox({Key? key}) : super(key: key);

  @override
  State<LobbyListBox> createState() => _LobbyListBoxState();
}

class _LobbyListBoxState extends State<LobbyListBox> {
  final double _cardHeightRatio = 0.08;

  @override
  Widget build(BuildContext context) {
    GameLobby gameLobby = Provider.of<GameLobby>(context);

    return Container(
      decoration: nMboxInvert,
      margin: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ListView.builder(
              itemCount: gameLobby.rooms().length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (BuildContext context, int index) {
                return lobbyInfoCard(
                    cardHeight: constraints.maxHeight * _cardHeightRatio,
                    owner: gameLobby.rooms()[index].owner,
                    publicRoom: true);
              });
        },
      ),
    );
  }

  Widget lobbyInfoCard(
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
              publicRoom ? Colors.green : Colors.red[700])
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
}
