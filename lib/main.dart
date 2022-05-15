import 'package:flutter/material.dart';
import 'package:mobile_chinese_chess/mainPage.dart';

void main() {
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
      home: const InGamePage(),
    );
  }
}
