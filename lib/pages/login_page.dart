import 'package:flutter/material.dart';
import 'package:mobile_chinese_chess/UI/game_ui.dart';
import 'package:mobile_chinese_chess/client/user.dart';
import 'package:mobile_chinese_chess/pages/lobby_page.dart';
import 'package:mobile_chinese_chess/utilities.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController userNameController = TextEditingController();

  LoginPage({Key? key}) : super(key: key);

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

    User.init(userNameController.text);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const LobbyPage();
    }));
  }
}
