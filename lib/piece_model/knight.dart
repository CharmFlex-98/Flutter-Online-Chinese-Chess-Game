import 'package:flutter/src/rendering/box.dart';
import 'package:mobile_chinese_chess/piece_model/piece.dart';
import 'package:mobile_chinese_chess/utilities.dart';

class Knight extends Piece {
  Knight(int xIndex, int yIndex, bool isRed, String imagePath)
      : super(xIndex, yIndex, isRed, imagePath);

  @override
  List<Point> possibleMovePoint(List<List<Piece?>> board) {
    List<Point> movePoint = [];
    killPoint = [];

    for (var i = -2; i <= 2; i++) {
      if (i == 0) continue;
      final dy = i;

      for (int sign in [1, -1]) {
        int dx = sign * (3 - dy.abs());

        bool noObstacle = movable(
            board,
            dy.abs() > dx.abs()
                ? Point(currentPoint.x, currentPoint.y + dy + dy.sign * -1)
                : Point(currentPoint.x + dx + dx.sign * -1, currentPoint.y));

        if (noObstacle) {
          Point point = Point(currentPoint.x + dx, currentPoint.y + dy);
          if (!inBoundary(point)) continue;

          appendAvailablePoint(board, point, movePoint, killPoint);
        }
      }
    }

    return movePoint;
  }

  bool movable(List<List<Piece?>> board, Point point) {
    if (!inBoundary(point)) return false;

    return board[point.x][point.y] == null;
  }
}
