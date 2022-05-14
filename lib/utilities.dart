import 'package:flutter/material.dart';

class SizeController {
  static late double _screenWidth;

  static late double _screenHeight;

  static late BuildContext _context;

  static void init(BuildContext context) {
    _context = context;
    _screenWidth = MediaQuery.of(context).size.width;
    _screenHeight = MediaQuery.of(context).size.height;
  }

  static double getScreenHeightWithAppBar(double ratio) {
    return (_screenHeight -
            MediaQuery.of(_context).padding.top -
            kBottomNavigationBarHeight) *
        ratio;
  }

  static double getScreenWidth(double ratio) {
    return _screenWidth * ratio;
  }

  static double? getScreenHeightWithoutAppBar() {
    return null;
  }
}

// this coordinate system is based on xy index on the board
class Point {
  int x;
  int y;

  Point(this.x, this.y);
}

class BoundingBoxPainter extends CustomPainter {
  double posX;
  double posY;
  double width;
  double height;
  Color color;

  BoundingBoxPainter(this.posX, this.posY, this.width, this.height, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    final a = Offset(posX, posY);
    final b = Offset(posX + width, posY + height);
    final rect = Rect.fromPoints(a, b);

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
