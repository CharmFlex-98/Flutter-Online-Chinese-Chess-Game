import 'room.dart';

class Player {
  final String _id;
  Player? _opponent;
  Room? _room;

  Player(this._id);

  String id() {
    return _id;
  }

  bool hasOpponent() {
    return _opponent != null;
  }

  bool inRoom() {
    return _room != null;
  }

  void pair(Player opponent) {
    _opponent = opponent;
  }

  void unpair() {
    _opponent = null;
  }
}
