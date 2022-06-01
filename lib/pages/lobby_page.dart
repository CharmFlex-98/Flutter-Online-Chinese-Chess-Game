import 'package:flutter/material.dart';
import 'package:mobile_chinese_chess/game_manager.dart';
import 'package:mobile_chinese_chess/pages/in_game_page.dart';
import 'package:mobile_chinese_chess/client/web_socket_client.dart';

class LobbyPage extends StatefulWidget {
  const LobbyPage({Key? key}) : super(key: key);

  @override
  State<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Mobile Chinese Chess Game")),
        body: Center(
          child: TextButton(
            onPressed: () {
              createPlayer(isRedTeam: true);
              enterGame();
            },
            child: const Text("Enter Game"),
          ),
        ));
  }

  void enterGame() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const InGamePage();
    }));
  }

  void createPlayer({bool isRedTeam = true}) {
    GameManager.init(isRedTeam: isRedTeam);
    WebSocketClient.send("1 player joined!");
  }
}
