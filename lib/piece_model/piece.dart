import 'package:mobile_chinese_chess/utilities.dart';

abstract class Piece {
  static const maxY = 9;
  static const maxX = 8;
  late Point initialPoint;
  late Point currentPoint;
  Point? tempPoint;
  String imagePath;
  bool isRed;
  late List<Point> killPoint = [];

  Piece(int xIndex, int yIndex, this.isRed, this.imagePath) {
    initialPoint = Point(xIndex, yIndex);
    currentPoint = Point(xIndex, yIndex); // avoid referencing
  }

  void resetPos() {
    move(initialPoint);
  }

  void move(Point toPoint) {
    // move logic here
    currentPoint.x = toPoint.x;
    currentPoint.y = toPoint.y;
  }

  bool inBoundary(Point point) {
    return (0 <= point.x && point.x <= Piece.maxX) &&
        (0 <= point.y && point.y <= Piece.maxY);
  }

  List<Point> possibleMovePoint(List<List<Piece?>> board);

  List<Point> possibleKillPoint(List<List<Piece?>> board) {
    return killPoint;
  }

  void appendAvailablePoint(List<List<Piece?>> board, Point targetPoint,
      List<Point> movePoint, List<Point> killPoint) {
    Piece? targetPiece = board[targetPoint.x][targetPoint.y];
    if (targetPiece == null) {
      movePoint.add(Point(targetPoint.x, targetPoint.y));
    } else {
      if (targetPiece.isRed != isRed) {
        killPoint.add(Point(targetPoint.x, targetPoint.y));
      }
    }
  }
}
