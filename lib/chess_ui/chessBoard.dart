import 'package:flutter/material.dart';
import 'package:mobile_chinese_chess/game_manager.dart';
import 'package:mobile_chinese_chess/piece_model/canon.dart';
import 'package:mobile_chinese_chess/piece_model/elephant.dart';
import 'package:mobile_chinese_chess/piece_model/guide.dart';
import 'package:mobile_chinese_chess/piece_model/king.dart';
import 'package:mobile_chinese_chess/piece_model/knight.dart';
import 'package:mobile_chinese_chess/piece_model/piece.dart';
import 'package:mobile_chinese_chess/piece_model/rook.dart';
import 'package:mobile_chinese_chess/piece_model/soldier.dart';
import 'package:mobile_chinese_chess/utilities.dart';

class ChessBoard extends StatefulWidget {
  final BoxConstraints constraints;
  late double pieceWidth;
  late double pieceHeight;
  late double xOffset;
  late double yOffset;
  late final List<Piece> pieces;
  late List<List<Piece?>> board;

  ChessBoard(this.constraints, {Key? key}) : super(key: key) {
    pieces = [
      // red
      Rook(0, 0, true, "assets/r_rook.png"),
      Knight(1, 0, true, "assets/r_knight.png"),
      Elephant(2, 0, true, "assets/r_elephant.png"),
      Guide(3, 0, true, "assets/r_guide.png"),
      King(4, 0, true, "assets/r_king.png"),
      Guide(5, 0, true, "assets/r_guide.png"),
      Elephant(6, 0, true, "assets/r_elephant.png"),
      Knight(7, 0, true, "assets/r_knight.png"),
      Rook(8, 0, true, "assets/r_rook.png"),
      Canon(1, 2, true, "assets/r_canon.png"),
      Canon(7, 2, true, "assets/r_canon.png"),
      Soldier(0, 3, true, "assets/r_soldier.png"),
      Soldier(2, 3, true, "assets/r_soldier.png"),
      Soldier(4, 3, true, "assets/r_soldier.png"),
      Soldier(6, 3, true, "assets/r_soldier.png"),
      Soldier(8, 3, true, "assets/r_soldier.png"),

      // black
      Rook(0, 9, false, "assets/b_rook.png"),
      Knight(1, 9, false, "assets/b_knight.png"),
      Elephant(2, 9, false, "assets/b_elephant.png"),
      Guide(3, 9, false, "assets/b_guide.png"),
      King(4, 9, false, "assets/b_king.png"),
      Guide(5, 9, false, "assets/b_guide.png"),
      Elephant(6, 9, false, "assets/b_elephant.png"),
      Knight(7, 9, false, "assets/b_knight.png"),
      Rook(8, 9, false, "assets/b_rook.png"),
      Canon(1, 7, false, "assets/b_canon.png"),
      Canon(7, 7, false, "assets/b_canon.png"),
      Soldier(0, 6, false, "assets/b_soldier.png"),
      Soldier(2, 6, false, "assets/b_soldier.png"),
      Soldier(4, 6, false, "assets/b_soldier.png"),
      Soldier(6, 6, false, "assets/b_soldier.png"),
      Soldier(8, 6, false, "assets/b_soldier.png"),
    ];

    initBoardDim();
    initBoard();
    GameManager.init();
  }

  void initBoard() {
    const row = 10;
    const column = 9;
    board =
        List.generate(column, (index) => List.generate(row, (index) => null));

    for (Piece piece in pieces) {
      final x = piece.initialPoint.x;
      final y = piece.initialPoint.y;

      board[x][y] = piece;
    }
  }

  void initBoardDim() {
    pieceWidth = constraints.maxWidth / 9;
    pieceHeight = constraints.maxHeight / 10;
    xOffset = 36 / 642 * constraints.maxWidth - pieceWidth / 2;
    yOffset = 31 / 720 * constraints.maxHeight - pieceHeight / 2;
  }

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  Piece? _selectedPiece;
  List<CustomPaint> moveBoundingBoxes = [];
  List<CustomPaint> killBoundingBoxes = [];

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [
      GestureDetector(
        onTapDown: (details) {
          if (_selectedPiece != null) {
            int xIndex = getXIndex(details.localPosition.dx);
            int yIndex = getYIndex(details.localPosition.dy);

            for (Point point
                in _selectedPiece!.possibleMovePoint(widget.board)) {
              if (point.x == xIndex && point.y == yIndex) {
                setState(() {
                  movePiece(_selectedPiece!, point);
                });

                break;
              }
            }
          }
        },
        child: Image.asset(
          "assets/chessBoard.png",
          fit: BoxFit.fill,
        ),
      ),
      for (Piece piece in piecesOnBoard()) positionPiece(piece),
      ...moveBoundingBoxes,
      ...killBoundingBoxes,
      GameManager.gameIsEnd()
          ? Container(
              color: GameManager.isRedTurn() == GameManager.isRedTeam()
                  ? Colors.green
                  : Colors.red,
              child: Text(GameManager.isRedTurn() == GameManager.isRedTeam()
                  ? "You win!"
                  : "You lose!"))
          : const SizedBox(),
    ]);
  }

  Widget positionPiece(Piece piece) {
    return Positioned(
        left: getXPos(piece),
        top: getYPos(piece),
        child: GestureDetector(
          onTap: () {
            setState(() {
              // when we select piece, we need to show
              // available move path and kill path
              // only a side is selectable
              piece.isRed == GameManager.isRedTurn()
                  ? selectPiece(piece)
                  : tryKillPiece(piece);
            });
          },
          child: SizedBox(
            height: widget.pieceHeight,
            width: widget.pieceWidth,
            child: Image.asset(
              piece.imagePath,
              fit: BoxFit.contain,
            ),
          ),
        ));
  }

  void tryKillPiece(Piece piece) {
    if (_selectedPiece == null) return;

    for (Point point in _selectedPiece!.possibleKillPoint(widget.board)) {
      if (piece.currentPoint.x == point.x && piece.currentPoint.y == point.y) {
        widget.board[piece.currentPoint.x][piece.currentPoint.y] =
            _selectedPiece;
        widget.board[_selectedPiece!.currentPoint.x]
            [_selectedPiece!.currentPoint.y] = null;
        _selectedPiece!.move(Point(piece.currentPoint.x, piece.currentPoint.y));
        postManipulationProcess();
        break;
      }
    }
  }

  void selectPiece(Piece piece) {
    if (_selectedPiece == piece) {
      deselectPiece();
      return;
    }

    drawAvailableMovePath(piece);
    drawAvailableKillPath(piece);
    _selectedPiece = piece;
  }

  void deselectPiece() {
    _selectedPiece = null;
    moveBoundingBoxes = [];
    killBoundingBoxes = [];
  }

  List<Piece> piecesOnBoard() {
    List<Piece> remainingPieces = [];

    for (List<Piece?> pieces in widget.board) {
      for (Piece? piece in pieces) {
        if (piece == null) continue;
        remainingPieces.add(piece);
      }
    }

    return remainingPieces;
  }

  void postManipulationProcess() {
    moveBoundingBoxes = [];
    killBoundingBoxes = [];
    _selectedPiece = null;
    GameManager.changeTurn();

    if (checkIfGameEnd(GameManager.isRedTurn())) GameManager.endGame();
  }

  void drawAvailableMovePath(Piece piece) {
    moveBoundingBoxes = [];
    // select itself too
    moveBoundingBoxes.add(CustomPaint(
      foregroundPainter: BoundingBoxPainter(
          getXPos(piece, xIndex: piece.currentPoint.x),
          getYPos(piece, yIndex: piece.currentPoint.y),
          widget.pieceWidth,
          widget.pieceHeight,
          Colors.green),
    ));

    for (Point point in piece.possibleMovePoint(widget.board)) {
      moveBoundingBoxes.add(CustomPaint(
        foregroundPainter: BoundingBoxPainter(
            getXPos(piece, xIndex: point.x),
            getYPos(piece, yIndex: point.y),
            widget.pieceWidth,
            widget.pieceHeight,
            Colors.green),
      ));
    }
  }

  void drawAvailableKillPath(Piece piece) {
    killBoundingBoxes = [];
    for (Point point in piece.possibleKillPoint(widget.board)) {
      killBoundingBoxes.add(
        CustomPaint(
          foregroundPainter: BoundingBoxPainter(
              getXPos(piece, xIndex: point.x),
              getYPos(piece, yIndex: point.y),
              widget.pieceWidth,
              widget.pieceHeight,
              Colors.red),
        ),
      );
    }
  }

  void movePiece(Piece piece, Point toPoint) {
    Point initialPoint = piece.currentPoint;

    widget.board[initialPoint.x][initialPoint.y] = null;
    widget.board[toPoint.x][toPoint.y] = piece;
    piece.move(toPoint);

    postManipulationProcess();
  }

  double getXPos(Piece piece, {int? xIndex}) {
    if (xIndex != null) {
      return widget.xOffset +
          xIndex * (widget.constraints.maxWidth * 565 / 642) / 8;
    }
    return widget.xOffset +
        piece.currentPoint.x * (widget.constraints.maxWidth * 565 / 642) / 8;
  }

  double getYPos(Piece piece, {int? yIndex}) {
    double offset =
        31 / 720 * widget.constraints.maxHeight - widget.pieceHeight / 2;

    if (yIndex != null) {
      return offset + yIndex * (widget.constraints.maxHeight * 660 / 720) / 9;
    }
    return offset +
        piece.currentPoint.y * (widget.constraints.maxHeight * 660 / 720) / 9;
  }

  int getXIndex(double xPos) {
    return ((xPos - widget.xOffset) /
            ((widget.constraints.maxWidth * 565 / 642) / 8))
        .floor();
  }

  int getYIndex(double yPos) {
    return ((yPos - widget.yOffset) /
            ((widget.constraints.maxHeight * 660 / 720) / 9))
        .floor();
  }

  // what is consider an ending match?
  // **if isRedTurn == true, enemy = black, else enemy = red**
  // 1. enemy killed your king...
  // 2. for every possible move, enemy can kill you
  // return true if game end and you lo
  bool checkIfGameEnd(bool isRedTurn) {
    // this is not so good because it rebuild every move
    List<Piece> enemyPieces = [];
    List<Piece> selfPieces = [];

    grouping(selfPieces, enemyPieces, isRedTurn);

    // 1.
    if (!kingExistedOnBoard(selfPieces)) return true;

    // 2.
    if (!tryAvoidGetKilled(selfPieces, enemyPieces, isRedTurn)) {
      return true;
    }

    return false;
  }

  bool kingExistedOnBoard(List<Piece> selfPieces) {
    for (Piece piece in selfPieces) {
      if (piece is King) {
        return true;
      }
    }

    return false;
  }

  // might need to increase the performance
  // return true if enemy king can be killed
  bool tryKillKing(
      List<List<Piece?>> fakeBoard, List<Piece> selfPieces, bool isRed) {
    for (Piece piece in selfPieces) {
      List<Point> allPossibleMovePoint = [
        ...piece.possibleMovePoint(fakeBoard),
        ...piece.possibleKillPoint(fakeBoard)
      ];
      for (Point movePoint in allPossibleMovePoint) {
        if (fakeBoard[movePoint.x][movePoint.y] == null) continue;
        Piece goingToBeKilledPiece = fakeBoard[movePoint.x][movePoint.y]!;

        if (goingToBeKilledPiece.isRed != isRed &&
            goingToBeKilledPiece is King) {
          return true;
        }
      }
    }

    return false;
  }

  // return false if impossible to avoid from getting killed.
  bool tryAvoidGetKilled(
      List<Piece> selfPieces, List<Piece> enemyPieces, bool isRedTurn) {
    for (Piece piece in selfPieces) {
      List<Point> allPossibleSelfMovePoint = [
        ...piece.possibleMovePoint(widget.board),
        ...piece.possibleKillPoint(widget.board)
      ];

      // for every self move,
      for (Point movePoint in allPossibleSelfMovePoint) {
        List<List<Piece?>> fakeBoard = [];
        for (List<Piece?> pieces in widget.board) {
          fakeBoard.add([...pieces]);
        }

        List<Piece> enemyPiecesClone = [...enemyPieces];

        enemyPiecesClone = enemyPiecesClone.where((enemyPiece) {
          return enemyPiece != fakeBoard[movePoint.x][movePoint.y];
        }).toList();
        fakeBoard[movePoint.x][movePoint.y] = piece;
        fakeBoard[piece.currentPoint.x][piece.currentPoint.y] = null;

        // if one enemy pieces can kill king,
        // we return false.
        if (!tryKillKing(fakeBoard, enemyPiecesClone, !isRedTurn)) {
          return true;
        }
      }
    }

    return false;
  }

  void grouping(List<Piece> selfPieces, List<Piece> enemyPieces, isRedTurn) {
    for (List<Piece?> pieces in widget.board) {
      for (Piece? piece in pieces) {
        if (piece == null) continue;

        if (piece.isRed == isRedTurn) {
          selfPieces.add(piece);
        } else if (piece.isRed != isRedTurn) {
          enemyPieces.add(piece);
        }
      }
    }
  }
}
