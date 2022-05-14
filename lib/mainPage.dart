import 'package:flutter/material.dart';
import 'package:mobile_chinese_chess/utilities.dart';

import 'chess_ui/chessBoard.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    SizeController.init(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Mobile Chinese Chess"),
        ),
        body: Column(children: [
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              return ChessBoard(constraints);
            }),
          ),
          Container(
            height: SizeController.getScreenHeightWithAppBar(0.15),
            width: double.infinity,
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: const Text("Here can display some text or stats"),
          )
        ]));
  }
}
