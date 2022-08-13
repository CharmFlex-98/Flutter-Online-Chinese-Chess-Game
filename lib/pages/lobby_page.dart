import 'package:flutter/material.dart';
import 'package:mobile_chinese_chess/UI/game_ui.dart';
import 'package:mobile_chinese_chess/client/constants.dart';
import 'package:mobile_chinese_chess/client/socket_methods.dart';
import 'package:mobile_chinese_chess/utilities.dart';
import 'package:mobile_chinese_chess/widgets/lobby_widgets/notification_banner.dart';
import 'package:provider/provider.dart';

import '../info/lobbyInfo.dart';
import '../widgets/lobby_widgets/room_list_box.dart';

class LobbyPage extends StatefulWidget {
  const LobbyPage({Key? key}) : super(key: key);

  @override
  State<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  @override
  void initState() {
    super.initState();
    SocketMethods methods = SocketMethods();
    methods.refreshLobbyListener(context);
    methods.createRoomSuccessedListener(context);
    methods.createRoomErrorListener();
  }

  @override
  void dispose() {
    SocketMethods()
        .disposeListeners([refreshLobby, createRoomSuccessed, createRoomError]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("build lobby");
    LobbyInfo lobbyInfo = Provider.of<LobbyInfo>(context);
    print(lobbyInfo);

    return Scaffold(
        backgroundColor: mC,
        appBar: AppBar(title: const Text("Mobile Chinese Chess Game")),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const NotificationBanner(),
            createLobbyBtn(),
            Expanded(
                child: RoomListBox(
              lobbyInfo: lobbyInfo,
            ))
          ],
        ));
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
}
