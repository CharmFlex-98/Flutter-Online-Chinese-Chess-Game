import 'package:flutter/material.dart';
import 'package:mobile_chinese_chess/UI/game_ui.dart';
import 'package:mobile_chinese_chess/constants.dart';
import 'package:mobile_chinese_chess/client/socket_methods.dart';
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
    SocketMethods().loginSucessedListener(context);
  }

  @override
  void dispose() {
    SocketMethods().disposeListeners([loginSuccessed]);
    super.dispose();
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
}
