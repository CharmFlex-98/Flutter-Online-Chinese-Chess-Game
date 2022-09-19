import 'package:flutter/material.dart';
import 'package:mobile_chinese_chess/constants.dart';
import 'package:mobile_chinese_chess/client/socket_methods.dart';
import 'package:mobile_chinese_chess/game_manager.dart';
import 'package:mobile_chinese_chess/info/opponent_move_info.dart';
import 'package:mobile_chinese_chess/info/room_info.dart';
import 'package:mobile_chinese_chess/piece_model/canon.dart';
import 'package:mobile_chinese_chess/piece_model/elephant.dart';
import 'package:mobile_chinese_chess/piece_model/guide.dart';
import 'package:mobile_chinese_chess/piece_model/king.dart';
import 'package:mobile_chinese_chess/piece_model/knight.dart';
import 'package:mobile_chinese_chess/piece_model/piece.dart';
import 'package:mobile_chinese_chess/piece_model/rook.dart';
import 'package:mobile_chinese_chess/piece_model/soldier.dart';
import 'package:mobile_chinese_chess/utilities.dart';
import 'package:provider/provider.dart';

class ChessBoard extends StatefulWidget {
  final BoxConstraints constraints;
  late final double xOffset;
  late final double yOffset;
  late final List<Piece> pieces;

  ChessBoard({required this.constraints, Key? key}) : super(key: key) {
    pieces = initPieces();
    initBoardDim();
  }

  void initBoardDim() {
    xOffset = 36 / 642 * constraints.maxWidth - getPieceWidth() / 2;
    yOffset = 31 / 720 * constraints.maxHeight - getPieceHeight() / 2;
  }

  List<Piece> initPieces() {
    GameManager gameManager = GameManager().instance();
    double pieceWidth = getPieceWidth();
    double pieceHeight = getPieceHeight();
    bool isRedTeam = gameManager.isRedTeam();
    if (isRedTeam) {
      return [
        // red
        Rook(pieceWidth, pieceHeight, 0, 9, true, "assets/r_rook.png"),
        Knight(pieceWidth, pieceHeight, 1, 9, true, "assets/r_knight.png"),
        Elephant(pieceWidth, pieceHeight, 2, 9, true, "assets/r_elephant.png"),
        Guide(pieceWidth, pieceHeight, 3, 9, true, "assets/r_guide.png"),
        King(pieceWidth, pieceHeight, 4, 9, true, "assets/r_king.png"),
        Guide(pieceWidth, pieceHeight, 5, 9, true, "assets/r_guide.png"),
        Elephant(pieceWidth, pieceHeight, 6, 9, true, "assets/r_elephant.png"),
        Knight(pieceWidth, pieceHeight, 7, 9, true, "assets/r_knight.png"),
        Rook(pieceWidth, pieceHeight, 8, 9, true, "assets/r_rook.png"),
        Canon(pieceWidth, pieceHeight, 1, 7, true, "assets/r_canon.png"),
        Canon(pieceWidth, pieceHeight, 7, 7, true, "assets/r_canon.png"),
        Soldier(pieceWidth, pieceHeight, 0, 6, true, "assets/r_soldier.png"),
        Soldier(pieceWidth, pieceHeight, 2, 6, true, "assets/r_soldier.png"),
        Soldier(pieceWidth, pieceHeight, 4, 6, true, "assets/r_soldier.png"),
        Soldier(pieceWidth, pieceHeight, 6, 6, true, "assets/r_soldier.png"),
        Soldier(pieceWidth, pieceHeight, 8, 6, true, "assets/r_soldier.png"),

        // black
        Rook(pieceWidth, pieceHeight, 0, 0, false, "assets/b_rook.png"),
        Knight(pieceWidth, pieceHeight, 1, 0, false, "assets/b_knight.png"),
        Elephant(pieceWidth, pieceHeight, 2, 0, false, "assets/b_elephant.png"),
        Guide(pieceWidth, pieceHeight, 3, 0, false, "assets/b_guide.png"),
        King(pieceWidth, pieceHeight, 4, 0, false, "assets/b_king.png"),
        Guide(pieceWidth, pieceHeight, 5, 0, false, "assets/b_guide.png"),
        Elephant(pieceWidth, pieceHeight, 6, 0, false, "assets/b_elephant.png"),
        Knight(pieceWidth, pieceHeight, 7, 0, false, "assets/b_knight.png"),
        Rook(pieceWidth, pieceHeight, 8, 0, false, "assets/b_rook.png"),
        Canon(pieceWidth, pieceHeight, 1, 2, false, "assets/b_canon.png"),
        Canon(pieceWidth, pieceHeight, 7, 2, false, "assets/b_canon.png"),
        Soldier(pieceWidth, pieceHeight, 0, 3, false, "assets/b_soldier.png"),
        Soldier(pieceWidth, pieceHeight, 2, 3, false, "assets/b_soldier.png"),
        Soldier(pieceWidth, pieceHeight, 4, 3, false, "assets/b_soldier.png"),
        Soldier(pieceWidth, pieceHeight, 6, 3, false, "assets/b_soldier.png"),
        Soldier(pieceWidth, pieceHeight, 8, 3, false, "assets/b_soldier.png"),
      ];
    }

    return [
      // red
      Rook(pieceWidth, pieceHeight, 0, 0, true, "assets/r_rook.png"),
      Knight(pieceWidth, pieceHeight, 1, 0, true, "assets/r_knight.png"),
      Elephant(pieceWidth, pieceHeight, 2, 0, true, "assets/r_elephant.png"),
      Guide(pieceWidth, pieceHeight, 3, 0, true, "assets/r_guide.png"),
      King(pieceWidth, pieceHeight, 4, 0, true, "assets/r_king.png"),
      Guide(pieceWidth, pieceHeight, 5, 0, true, "assets/r_guide.png"),
      Elephant(pieceWidth, pieceHeight, 6, 0, true, "assets/r_elephant.png"),
      Knight(pieceWidth, pieceHeight, 7, 0, true, "assets/r_knight.png"),
      Rook(pieceWidth, pieceHeight, 8, 9, true, "assets/r_rook.png"),
      Canon(pieceWidth, pieceHeight, 1, 2, true, "assets/r_canon.png"),
      Canon(pieceWidth, pieceHeight, 7, 2, true, "assets/r_canon.png"),
      Soldier(pieceWidth, pieceHeight, 0, 3, true, "assets/r_soldier.png"),
      Soldier(pieceWidth, pieceHeight, 2, 3, true, "assets/r_soldier.png"),
      Soldier(pieceWidth, pieceHeight, 4, 3, true, "assets/r_soldier.png"),
      Soldier(pieceWidth, pieceHeight, 6, 3, true, "assets/r_soldier.png"),
      Soldier(pieceWidth, pieceHeight, 8, 3, true, "assets/r_soldier.png"),

      // black
      Rook(pieceWidth, pieceHeight, 0, 9, false, "assets/b_rook.png"),
      Knight(pieceWidth, pieceHeight, 1, 9, false, "assets/b_knight.png"),
      Elephant(pieceWidth, pieceHeight, 2, 9, false, "assets/b_elephant.png"),
      Guide(pieceWidth, pieceHeight, 3, 9, false, "assets/b_guide.png"),
      King(pieceWidth, pieceHeight, 4, 9, false, "assets/b_king.png"),
      Guide(pieceWidth, pieceHeight, 5, 9, false, "assets/b_guide.png"),
      Elephant(pieceWidth, pieceHeight, 6, 9, false, "assets/b_elephant.png"),
      Knight(pieceWidth, pieceHeight, 7, 9, false, "assets/b_knight.png"),
      Rook(pieceWidth, pieceHeight, 8, 9, false, "assets/b_rook.png"),
      Canon(pieceWidth, pieceHeight, 1, 7, false, "assets/b_canon.png"),
      Canon(pieceWidth, pieceHeight, 7, 7, false, "assets/b_canon.png"),
      Soldier(pieceWidth, pieceHeight, 0, 6, false, "assets/b_soldier.png"),
      Soldier(pieceWidth, pieceHeight, 2, 6, false, "assets/b_soldier.png"),
      Soldier(pieceWidth, pieceHeight, 4, 6, false, "assets/b_soldier.png"),
      Soldier(pieceWidth, pieceHeight, 6, 6, false, "assets/b_soldier.png"),
      Soldier(pieceWidth, pieceHeight, 8, 6, false, "assets/b_soldier.png"),
    ];
  }

  @override
  State<ChessBoard> createState() => _ChessBoardState();

  double getPieceWidth() {
    return constraints.maxWidth / 9;
  }

  double getPieceHeight() {
    return constraints.maxHeight / 10;
  }
}

class _ChessBoardState extends State<ChessBoard> {
  late List<List<Piece?>> board;
  Piece? _selectedPiece;
  List<CustomPaint> moveBoundingBoxes = [];
  List<CustomPaint> killBoundingBoxes = [];

  void initBoard() {
    const row = 10;
    const column = 9;
    board =
        List.generate(column, (index) => List.generate(row, (index) => null));

    for (Piece piece in widget.pieces) {
      final x = piece.initialPoint.x;
      final y = piece.initialPoint.y;
      piece.currentPoint = Point(x, y);

      board[x][y] = piece;
    }
  }

  GameManager gameManager() {
    return GameManager().instance();
  }

  @override
  void initState() {
    super.initState();
    initBoard();
    SocketMethods().playerMoveListener(context, opponentMove);
    SocketMethods().gameStatusChangedListener(context, restart);
    SocketMethods().opponentLeftGameListener(context);
  }

  @override
  void dispose() {
    SocketMethods()
        .disposeListeners([playerMove, gameStatusChanged, opponentLeftGame]);
    super.dispose();
  }

  void restart() {
    gameManager().restartGame();
    setState(() {
      initBoard();
    });
  }

  void opponentMove(OpponentMoveInfo moveInfo) {
    Point? prevPoint = moveInfo.prevPoint;
    Point? currPoint = moveInfo.currPoint;

    if (prevPoint != null && currPoint != null) {
      Piece? selectedPiece = board[prevPoint.x][prevPoint.y];
      if (selectedPiece != null) {
        setState(() {
          move(board, selectedPiece, prevPoint, currPoint);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [
      GestureDetector(
        onTapDown: (details) {
          if (_selectedPiece != null) {
            int xIndex = getXIndex(details.localPosition.dx);
            int yIndex = getYIndex(details.localPosition.dy);

            for (Point point in _selectedPiece!.possibleMovePoint(board)) {
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
              piece.isRed == gameManager().isRedTurn()
                  ? selectPiece(piece)
                  : tryKillPiece(piece);
            });
          },
          child: SizedBox(
            height: piece.pieceHeight,
            width: piece.pieceWidth,
            child: Image.asset(
              piece.imagePath,
              fit: BoxFit.contain,
            ),
          ),
        ));
  }

  void tryKillPiece(Piece piece) {
    if (_selectedPiece == null) return;

    for (Point point in _selectedPiece!.possibleKillPoint(board)) {
      if (piece.currentPoint.x == point.x && piece.currentPoint.y == point.y) {
        int prevX = _selectedPiece!.currentPoint.x;
        int prevY = _selectedPiece!.currentPoint.y;

        move(board, _selectedPiece!, Point(prevX, prevY),
            Point(piece.currentPoint.x, piece.currentPoint.y));
        postManipulationProcess(
            prevX: prevX,
            currX: piece.currentPoint.x,
            prevY: prevY,
            currY: piece.currentPoint.y);
        break;
      }
    }
  }

  void selectPiece(Piece piece) {
    // if the piece is not your fucking piece
    if (piece.isRed != gameManager().isRedTeam()) return;

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

    for (List<Piece?> pieces in board) {
      for (Piece? piece in pieces) {
        if (piece == null) continue;
        remainingPieces.add(piece);
      }
    }

    return remainingPieces;
  }

  void postManipulationProcess(
      {required int prevX,
      required int currX,
      required int prevY,
      required int currY}) {
    RoomInfo roomInfo = Provider.of<RoomInfo>(context, listen: false);
    moveBoundingBoxes = [];
    killBoundingBoxes = [];
    _selectedPiece = null;
    SocketMethods().move(
        roomID: roomInfo.roomID!,
        prevX: prevX,
        currX: currX,
        prevY: prevY,
        currY: currY);

    if (checkIfGameEnd(gameManager().isRedTurn())) {
      gameManager().endGame(redWin: !gameManager().isRedTurn());
      RoomInfo roomInfo = Provider.of<RoomInfo>(context, listen: false);
      SocketMethods().endGame(roomInfo.roomID!, gameManager().win());
    }
  }

  void drawAvailableMovePath(Piece piece) {
    moveBoundingBoxes = [];
    // select itself too
    moveBoundingBoxes.add(CustomPaint(
      foregroundPainter: BoundingBoxPainter(
          getXPos(piece, xIndex: piece.currentPoint.x),
          getYPos(piece, yIndex: piece.currentPoint.y),
          piece.pieceWidth,
          piece.pieceHeight,
          Colors.green),
    ));

    for (Point point in piece.possibleMovePoint(board)) {
      moveBoundingBoxes.add(CustomPaint(
        foregroundPainter: BoundingBoxPainter(
            getXPos(piece, xIndex: point.x),
            getYPos(piece, yIndex: point.y),
            piece.pieceWidth,
            piece.pieceHeight,
            Colors.green),
      ));
    }
  }

  void drawAvailableKillPath(Piece piece) {
    killBoundingBoxes = [];
    for (Point point in piece.possibleKillPoint(board)) {
      killBoundingBoxes.add(
        CustomPaint(
          foregroundPainter: BoundingBoxPainter(
              getXPos(piece, xIndex: point.x),
              getYPos(piece, yIndex: point.y),
              piece.pieceWidth,
              piece.pieceHeight,
              Colors.red),
        ),
      );
    }
  }

  void movePiece(Piece piece, Point toPoint) {
    int prevX = piece.currentPoint.x;
    int prevY = piece.currentPoint.y;

    move(board, piece, Point(prevX, prevY), toPoint);

    postManipulationProcess(
        prevX: prevX,
        currX: piece.currentPoint.x,
        prevY: prevY,
        currY: piece.currentPoint.y);
  }

  void move(
      List<List<Piece?>> board, Piece piece, Point fromPoint, Point toPoint) {
    board[fromPoint.x][fromPoint.y] = null;
    board[toPoint.x][toPoint.y] = piece;
    piece.move(toPoint);
    gameManager().changeTurn();
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
        31 / 720 * widget.constraints.maxHeight - piece.pieceHeight / 2;

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

  bool checkIfGameEnd(bool isRedTurn) {
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
        // print(fakeBoard);
        // print(
        //     "$goingToBeKilledPiece, who kill? $piece, ${movePoint.x}, ${movePoint.y}");

        if (goingToBeKilledPiece.isRed != isRed &&
            goingToBeKilledPiece is King) {
          // testing(fakeBoard, piece);
          // print(fakeBoard);

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
        ...piece.possibleMovePoint(board),
        ...piece.possibleKillPoint(board)
      ];

      // for every self move,
      for (Point movePoint in allPossibleSelfMovePoint) {
        List<List<Piece?>> fakeBoard = [];
        for (List<Piece?> pieces in board) {
          fakeBoard.add([...pieces]);
        }

        List<Piece> enemyPiecesClone = [...enemyPieces];

        enemyPiecesClone = enemyPiecesClone.where((enemyPiece) {
          return enemyPiece != fakeBoard[movePoint.x][movePoint.y];
        }).toList();
        fakeBoard[movePoint.x][movePoint.y] = piece;
        fakeBoard[piece.currentPoint.x][piece.currentPoint.y] = null;

        // temporarily change the current point
        piece.tempPoint = Point(piece.currentPoint.x, piece.currentPoint.y);
        piece.currentPoint.x = movePoint.x;
        piece.currentPoint.y = movePoint.y;

        // if one enemy pieces can kill king,
        // we return false.
        if (!tryKillKing(fakeBoard, enemyPiecesClone, !isRedTurn)) {
          // restore current point
          piece.currentPoint = piece.tempPoint!;

          return true;
        }

        //restire current point
        piece.currentPoint = piece.tempPoint!;
      }
    }

    return false;
  }

  void grouping(List<Piece> selfPieces, List<Piece> enemyPieces, isRedTurn) {
    for (List<Piece?> pieces in board) {
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
