import 'package:flutter/material.dart';
import 'package:mobile_chinese_chess/UI/game_ui.dart';
import 'package:mobile_chinese_chess/constants.dart';
import 'package:mobile_chinese_chess/info/gameStatusInfo.dart';
import 'package:mobile_chinese_chess/info/lobbyInfo.dart';
import 'package:mobile_chinese_chess/info/roomInfo.dart';
import 'package:mobile_chinese_chess/pages/in_game_page.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LobbyInfo()),
        ChangeNotifierProvider(create: (_) => RoomInfo()),
        ChangeNotifierProvider(create: (_) => GameStatusInfo())
      ],
      child: MaterialApp(
        color: mC,
        title: 'Mobile Chinese Chess',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: loginPage,
        routes: {
          loginPage: (context) => const LoginPage(),
          lobbyPage: (context) => LobbyPage(),
          inGamePage: (context) => InGamePage()
        },
      ),
    );
  }
}
