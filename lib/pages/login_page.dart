import 'package:flutter/material.dart';
import 'package:mobile_chinese_chess/UI/game_ui.dart';
import 'package:mobile_chinese_chess/client/socket_client.dart';
import 'package:mobile_chinese_chess/client/socket_methods.dart';
import 'package:mobile_chinese_chess/gameInfo/userInfo.dart';
import 'package:mobile_chinese_chess/pages/lobby_page.dart';
import 'package:mobile_chinese_chess/utilities.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    socketListenerCB();
  }

  @override
  Widget build(BuildContext context) {
    SizeController.init(context);

    return Scaffold(
        backgroundColor: mC,
        appBar: AppBar(title: const Text("Mobile Chinese Chess Game")),
        body: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            controller: userNameController,
          ),
          TextButton(
              onPressed: () {
                loginUser(context);
              },
              child: const Text("Login"))
        ])));
  }

  void loginUser(BuildContext context) {
    if (userNameController.text.isEmpty) return;

    SocketMethods().loginUser(userNameController.text);
  }

  void socketListenerCB() {
    final socket = SocketClient.instance().socket!;

    socket.on("loginSuccess", (data) {
      UserInfo.initUser(data["username"]);
      enterLobby(data);
    });
  }

  void enterLobby(dynamic data) {
    print("data before lobby");
    print(data);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LobbyPage(
        info: data,
      );
    }));
  }
}
