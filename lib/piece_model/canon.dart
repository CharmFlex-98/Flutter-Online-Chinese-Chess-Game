import 'package:mobile_chinese_chess/piece_model/piece.dart';
import 'package:mobile_chinese_chess/utilities.dart';

class Canon extends Piece {
  Canon(int xIndex, int yIndex, bool isRed, String imagePath)
      : super(xIndex, yIndex, isRed, imagePath);

  @override
  List<Point> possibleMovePoint(List<List<Piece?>> board) {
    List<Point> movePoint = [];
    killPoint = [];
    // down
    for (var y = currentPoint.y + 1; y <= Piece.maxY; y++) {
      if (board[currentPoint.x][y] != null) {
        for (var nextY = y + 1; nextY <= 9; nextY++) {
          if (!continueAppendKillPoint(
              board[currentPoint.x][nextY], killPoint)) {
            break;
          }
        }
        break;
      }
      movePoint.add(Point(currentPoint.x, y));
    }

    // up
    for (var y = currentPoint.y - 1; y >= 0; y--) {
      if (board[currentPoint.x][y] != null) {
        for (var nextY = y - 1; nextY >= 0; nextY--) {
          print(nextY);
          if (!continueAppendKillPoint(
              board[currentPoint.x][nextY], killPoint)) {
            break;
          }
        }
        break;
      }
      movePoint.add(Point(currentPoint.x, y));
    }

    // left
    for (var x = currentPoint.x - 1; x >= 0; x--) {
      if (board[x][currentPoint.y] != null) {
        for (var nextX = x - 1; nextX >= 0; nextX--) {
          if (!continueAppendKillPoint(
              board[nextX][currentPoint.y], killPoint)) {
            break;
          }
        }
        break;
      }
      movePoint.add(Point(x, currentPoint.y));
    }

    // right
    for (var x = currentPoint.x + 1; x <= Piece.maxX; x++) {
      if (board[x][currentPoint.y] != null) {
        for (var nextX = x + 1; nextX <= 8; nextX++) {
          if (!continueAppendKillPoint(
              board[nextX][currentPoint.y], killPoint)) {
            break;
          }
        }
        break;
      }

      movePoint.add(Point(x, currentPoint.y));
    }

    return movePoint;
  }

  bool continueAppendKillPoint(Piece? piece, List<Point> killPoint) {
    if (piece == null) return true;

    if (piece.isRed != isRed) {
      killPoint.add(piece.currentPoint);
    }

    return false;
  }
}
