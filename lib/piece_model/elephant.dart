import 'package:flutter/rendering.dart';
import 'package:mobile_chinese_chess/piece_model/piece.dart';
import 'package:mobile_chinese_chess/utilities.dart';

class Elephant extends Piece {
  Elephant(double pieceWidth, double pieceHeight, int xIndex, int yIndex,
      bool isRed, String imagePath)
      : super(pieceWidth, pieceHeight, xIndex, yIndex, isRed, imagePath);

  @override
  List<Point> possibleMovePoint(List<List<Piece?>> board) {
    List<Point> movePoint = [];
    killPoint = [];

    for (int dx in [-2, 2]) {
      for (int dy in [-2, 2]) {
        Point obstaclePoint = Point(currentPoint.x + dx + dx.sign * -1,
            currentPoint.y + dy + dy.sign * -1);
        if (inBoundary(obstaclePoint) &&
            inBoundary(Point(currentPoint.x + dx, currentPoint.y + dy))) {
          appendAvailablePoint(
              board,
              Point(currentPoint.x + dx, currentPoint.y + dy),
              movePoint,
              killPoint);
        }
      }
    }

    return movePoint;
  }
}
