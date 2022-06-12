import 'package:flutter/material.dart';
import 'package:mobile_chinese_chess/UI/game_ui.dart';
import 'package:mobile_chinese_chess/client/game_lobby.dart';
import 'package:mobile_chinese_chess/client/user.dart';
import 'package:mobile_chinese_chess/client/waiting_room.dart';
import 'package:mobile_chinese_chess/pages/lobby_page.dart';
import 'package:mobile_chinese_chess/pages/login_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: mC,
      title: 'Mobile Chinese Chess',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
