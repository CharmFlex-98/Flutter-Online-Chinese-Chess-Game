import 'package:flutter/material.dart';
import 'package:mobile_chinese_chess/client/player.dart';
import 'package:mobile_chinese_chess/client/room.dart';
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
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                initializeGame("Ming", "testingRoom", isRedTeam: true);
                //enterGame();
              },
              child: const Text("Enter Game"),
            ),
            TextButton(
              onPressed: () {
                initializeGame("Chi", "testingRoom", isRedTeam: false);
                // enterGame();
              },
              child: const Text("Enter Game"),
            ),
          ],
        )));
  }

  void enterGame() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const InGamePage();
    }));
  }

  Player createPlayer(String playerId, {bool isRedTeam = true}) {
    GameManager.init(isRedTeam: isRedTeam);
    Player player = Player(playerId);

    return player;
  }

  // just for testing
  Room createRoom(String roomId) {
    Room room = Room(roomId);

    return room;
  }

  void initializeGame(String playerId, String roomId, {bool isRedTeam = true}) {
    Player player = createPlayer(playerId, isRedTeam: isRedTeam);
    Room room = createRoom(roomId);

    room.join(player);
  }
}
