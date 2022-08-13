import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:mobile_chinese_chess/UI/game_ui.dart';
import 'package:mobile_chinese_chess/client/socket_client.dart';
import 'package:mobile_chinese_chess/utilities.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../info/userInfo.dart';

class NotificationBanner extends StatefulWidget {
  const NotificationBanner({Key? key}) : super(key: key);

  @override
  State<NotificationBanner> createState() => _NotificationBannerState();
}

class _NotificationBannerState extends State<NotificationBanner> {
  String bannerMessage =
      "Welcome ${UserInfo.username}! Have fun playing chinese chess!";
  @override
  void initState() {
    super.initState();
    socketListenerCB();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      height: SizeController.getScreenHeightWithAppBar(0.1),
      width: double.infinity,
      margin: const EdgeInsets.all(8),
      decoration: nMboxInvert,
      child: _buildMarquee(),
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

  Widget _buildMarquee() {
    return Marquee(
      key: Key(bannerMessage),
      style: const TextStyle(fontSize: 15),
      text: bannerMessage,
      velocity: 100.0,
      numberOfRounds: 1,
      startPadding: SizeController.getScreenWidth(1),
      blankSpace: SizeController.getScreenWidth(1),
    );
  }

  void socketListenerCB() {
    Socket socket = SocketClient.instance().socket!;

    socket.on("playerJoinedLobby", (data) {
      setState(() {
        bannerMessage = data["message"];
      });
    });
  }
}
