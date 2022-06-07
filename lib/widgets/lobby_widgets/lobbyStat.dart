import 'package:flutter/material.dart';
import 'package:mobile_chinese_chess/UI/game_ui.dart';
import 'package:mobile_chinese_chess/utilities.dart';

class LobbyStat extends StatelessWidget {
  const LobbyStat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      height: SizeController.getScreenHeightWithAppBar(0.1),
      width: double.infinity,
      margin: const EdgeInsets.all(8),
      decoration: nMboxInvert,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [Text("LOBBY STATUS")]),
    );
  }

  Widget title() {
    return Container(
      decoration: nMbtn,
      child: const Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            "LOBBY",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
    );
  }
}
