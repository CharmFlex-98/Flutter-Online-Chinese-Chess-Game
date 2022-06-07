import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_chinese_chess/UI/game_ui.dart';
import 'package:mobile_chinese_chess/client/game_lobby.dart';
import 'package:mobile_chinese_chess/client/user.dart';
import 'package:mobile_chinese_chess/client/waiting_room.dart';
import 'package:mobile_chinese_chess/widgets/waiting_room_widget.dart';
import 'package:mobile_chinese_chess/client/web_socket_client.dart';
import 'package:mobile_chinese_chess/utilities.dart';
import 'package:mobile_chinese_chess/widgets/lobby_widgets/lobbyStat.dart';
import 'package:mobile_chinese_chess/widgets/lobby_widgets/lobby_list_box.dart';
import 'package:provider/provider.dart';

class LobbyPage extends StatefulWidget {
  const LobbyPage({Key? key}) : super(key: key);

  @override
  State<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  @override
  void initState() {
    WebSocketClient.init();
    WebSocketClient.send("refresh lobby");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mC,
        appBar: AppBar(title: const Text("Mobile Chinese Chess Game")),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const LobbyStat(),
            createLobbyBtn(),
            const Expanded(child: LobbyListBox())
          ],
        ));
  }

  void createRoom() {
    showModalBottomSheet(
        context: context,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        builder: (context) {
          return const WaitingRoomWidget();
        });
    WebSocketClient.send("create room");
  }

  Widget createLobbyBtn() {
    return GestureDetector(
      onTap: createRoom,
      child: Container(
        margin: const EdgeInsets.all(8),
        alignment: Alignment.center,
        width: SizeController.getScreenWidth(0.2),
        height: SizeController.getScreenHeightWithAppBar(0.05),
        decoration: nMbtn,
        child: const FittedBox(
            child: Text(
          "New Room",
          style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
        )),
      ),
    );
  }

  void newPlayerJoinNotification() {
    Fluttertoast.cancel();
    Fluttertoast.showToast(msg: "New player joined!");
  }

  // void enterGame() {
  //   Navigator.push(context, MaterialPageRoute(builder: (context) {
  //     return const InGamePage();
  //   }));
  // }

  // Player createPlayer(String playerId, {bool isRedTeam = true}) {
  //   GameManager.init(isRedTeam: isRedTeam);
  //   Player player = Player(playerId);

  //   return player;
  // }

  // // just for testing
  // Room createRoom(String roomId) {
  //   Room room = Room(roomId);

  //   return room;
  // }

  // void initializeGame(String playerId, String roomId, {bool isRedTeam = true}) {
  //   Player player = createPlayer(playerId, isRedTeam: isRedTeam);
  //   Room room = createRoom(roomId);

  //   room.join(player);
  // }
}
