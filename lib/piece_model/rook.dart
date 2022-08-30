import 'package:mobile_chinese_chess/piece_model/piece.dart';
import 'package:mobile_chinese_chess/utilities.dart';

class Rook extends Piece {
  Rook(double pieceWidth, double pieceHeight, int xIndex, int yIndex,
      bool isRed, String imagePath)
      : super(pieceWidth, pieceHeight, xIndex, yIndex, isRed, imagePath);

  @override
  List<Point> possibleMovePoint(List<List<Piece?>> board) {
    List<Point> movePoint = [];
    killPoint = [];

    // down
    for (var y = currentPoint.y + 1; y <= Piece.maxY; y++) {
      appendAvailablePoint(
          board, Point(currentPoint.x, y), movePoint, killPoint);
      if (board[currentPoint.x][y] != null) break;
    }

    // up
    for (var y = currentPoint.y - 1; y >= 0; y--) {
      appendAvailablePoint(
          board, Point(currentPoint.x, y), movePoint, killPoint);
      if (board[currentPoint.x][y] != null) break;
    }

    // left
    for (var x = currentPoint.x - 1; x >= 0; x--) {
      appendAvailablePoint(
          board, Point(x, currentPoint.y), movePoint, killPoint);
      if (board[x][currentPoint.y] != null) break;
    }

    // right
    for (var x = currentPoint.x + 1; x <= Piece.maxX; x++) {
      appendAvailablePoint(
          board, Point(x, currentPoint.y), movePoint, killPoint);
      if (board[x][currentPoint.y] != null) break;
    }

    return movePoint;
  }
}
