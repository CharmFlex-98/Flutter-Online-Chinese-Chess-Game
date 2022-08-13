import 'package:flutter/material.dart';
import 'package:mobile_chinese_chess/UI/chessBoard.dart';
import 'package:mobile_chinese_chess/utilities.dart';

class InGamePage extends StatefulWidget {
  const InGamePage({Key? key}) : super(key: key);

  @override
  _InGamePageState createState() => _InGamePageState();
}

class _InGamePageState extends State<InGamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Mobile Chinese Chess"),
        ),
        body: Column(children: [
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              return ChessBoard(constraints: constraints);
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
