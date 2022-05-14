import 'package:flutter/material.dart';
import 'package:mobile_chinese_chess/piece_model/piece.dart';
import 'package:mobile_chinese_chess/utilities.dart';

class King extends Piece {
  King(int xIndex, int yIndex, bool isRed, String imagePath)
      : super(xIndex, yIndex, isRed, imagePath);

  @override
  List<Point> possibleMovePoint(List<List<Piece?>> board) {
    List<Point> movePoint = [];
    killPoint = [];

    // left
    if (currentPoint.x - 1 >= 3) {
      appendAvailablePoint(board, Point(currentPoint.x - 1, currentPoint.y),
          movePoint, killPoint);
    }

    // right
    if (currentPoint.x + 1 <= 5) {
      appendAvailablePoint(board, Point(currentPoint.x + 1, currentPoint.y),
          movePoint, killPoint);
    }

    // up
    if ((currentPoint.y - 1 >= 7 && currentPoint.y - 1 <= 9) ||
        (currentPoint.y - 1 >= 0 && currentPoint.y - 1 <= 2)) {
      appendAvailablePoint(board, Point(currentPoint.x, currentPoint.y - 1),
          movePoint, killPoint);
    }

    // down
    if ((currentPoint.y + 1 <= 9 && currentPoint.y + 1 >= 7) ||
        (currentPoint.y + 1 <= 2 && currentPoint.y + 1 >= 0)) {
      appendAvailablePoint(board, Point(currentPoint.x + 1, currentPoint.y),
          movePoint, killPoint);
    }

    return movePoint;
  }

  @override
  List<Point> possibleKillPoint(List<List<Piece?>> board) {
    // TODO: implement possibleKillPoint
    throw UnimplementedError();
  }
}
