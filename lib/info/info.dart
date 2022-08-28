import 'package:flutter/material.dart';

abstract class Info extends ChangeNotifier {
  String keyword();

  void updateInfo(dynamic data);

  void notify() {
    return notifyListeners();
  }
}
