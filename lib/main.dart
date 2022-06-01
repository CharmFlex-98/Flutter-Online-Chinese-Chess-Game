import 'package:flutter/material.dart';
import 'package:mobile_chinese_chess/pages/in_game_page.dart';
import 'package:mobile_chinese_chess/pages/lobby_page.dart';
import 'package:mobile_chinese_chess/client/web_socket_client.dart';

void main() {
  WebSocketClient.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Chinese Chess',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LobbyPage(),
    );
  }
}
