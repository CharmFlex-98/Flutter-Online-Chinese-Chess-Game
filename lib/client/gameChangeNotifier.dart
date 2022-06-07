import 'package:flutter/cupertino.dart';

class GameChangeNotifier extends ChangeNotifier {
  late dynamic _receivedInfo;
  String key;

  GameChangeNotifier(this.key);

  dynamic getReceivedInfo() {
    return _receivedInfo[key];
  }

  // concerete implementation in subclasses
  bool update() {
    return false;
  }

  bool isTargetListener({required dynamic receivedInfo}) {
    _receivedInfo = receivedInfo;
    return false;
  }
}
