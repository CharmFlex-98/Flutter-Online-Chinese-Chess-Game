import 'package:flutter/src/rendering/box.dart';
import 'package:mobile_chinese_chess/piece_model/piece.dart';
import 'package:mobile_chinese_chess/utilities.dart';

class Soldier extends Piece {
  Soldier(int xIndex, int yIndex, bool isRed, String imagePath)
      : super(xIndex, yIndex, isRed, imagePath);

  @override
  List<Point> possibleMovePoint(List<List<Piece?>> board) {
    List<Point> movePoint = [];
    killPoint = [];
    bool isEnemy = initialPoint.y == 3;
    int dy = isEnemy ? 1 : -1;

    if (currentPoint.y + dy >= 0 && currentPoint.y + dy <= 9) {
      appendAvailablePoint(board, Point(currentPoint.x, currentPoint.y + dy),
          movePoint, killPoint);
    }

    if ((currentPoint.y - initialPoint.y).abs() >= 2) {
      if (currentPoint.x - 1 >= 0) {
        appendAvailablePoint(board, Point(currentPoint.x - 1, currentPoint.y),
            movePoint, killPoint);
      }
      if (currentPoint.x + 1 <= 8) {
        appendAvailablePoint(board, Point(currentPoint.x + 1, currentPoint.y),
            movePoint, killPoint);
      }
    }

    return movePoint;
  }
}
