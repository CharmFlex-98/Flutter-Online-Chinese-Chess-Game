import 'package:flutter/material.dart';
import 'package:mobile_chinese_chess/piece_model/piece.dart';
import 'package:mobile_chinese_chess/utilities.dart';

class Guide extends Piece {
  Guide(double pieceWidth, double pieceHeight, int xIndex, int yIndex,
      bool isRed, String imagePath)
      : super(pieceWidth, pieceHeight, xIndex, yIndex, isRed, imagePath);

  @override
  List<Point> possibleMovePoint(List<List<Piece?>> board) {
    List<Point> movePoint = [];
    killPoint = [];

    for (int dx in [-1, 1]) {
      for (int dy in [-1, 1]) {
        if (inGuideBoundary(Point(currentPoint.x + dx, currentPoint.y + dy))) {
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

  bool inGuideBoundary(Point point) {
    return point.x >= 3 &&
        point.x <= 5 &&
        ((point.y >= 0 && point.y <= 2) || (point.y <= 9 && point.y >= 7));
  }
}
