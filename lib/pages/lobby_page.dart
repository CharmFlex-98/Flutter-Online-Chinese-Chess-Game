import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_chinese_chess/UI/game_ui.dart';
import 'package:mobile_chinese_chess/client/socket_client.dart';
import 'package:mobile_chinese_chess/client/socket_methods.dart';
import 'package:mobile_chinese_chess/utilities.dart';
import 'package:mobile_chinese_chess/widgets/lobby_widgets/lobbyStat.dart';

import '../gameInfo/lobbyInfo.dart';
import '../widgets/lobby_widgets/room_list_box.dart';
import '../widgets/waiting_room_widget.dart';

class LobbyPage extends StatefulWidget {
  dynamic info;
  LobbyPage({required this.info, Key? key}) : super(key: key);

  @override
  State<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  LobbyInfo lobbyInfo = LobbyInfo();

  @override
  void initState() {
    super.initState();
    print("login info is");
    print(widget.info);
    lobbyInfo.updateInfo(widget.info);
    socketListenerCB();
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
            Expanded(
                child: RoomListBox(
              lobbyInfo: lobbyInfo,
            ))
          ],
        ));
  }

  void createRoom(dynamic data) {
    print("at create room");
    print(data);
    showModalBottomSheet(
        isDismissible: false,
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

  Widget createLobbyBtn() {
    return GestureDetector(
      onTap: SocketMethods().createRoom,
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

  void socketListenerCB() {
    final socket = SocketClient.instance().socket!;

    socket.on("refreshLobby", (data) {
      if (data["onlinePlayers"] != null) {
      } else if (data["lobbyInfo"] != null) {
        setState(() {
          lobbyInfo.updateInfo(data);
        });
      }
    });

    socket.on("createRoomSuccessed", (data) {
      createRoom(data);
    });

    socket.on("error", (data) {
      Fluttertoast.showToast(
          msg: "failing to create room! Check your connection!");
    });
  }

  // void createRoom() {

  // }

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
