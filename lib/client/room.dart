import 'player.dart';
import 'package:mobile_chinese_chess/client/web_socket_client.dart';

class Room {
  final int _id;
  final String owner;
  List<dynamic> players = [];

  Room(this._id, this.owner, this.players);

  int id() {
    return _id;
  }

  bool isEmpty() {
    return players.isEmpty;
  }

  bool canJoin() {
    return players.length < 2;
  }

  bool join(Player player) {
    if (canJoin()) {
      players.add(player);

      String message = "${player.id()} joined!";

      WebSocketClient.send(message);
      return true;
    }

    return false;
  }

  // id is the player id
  void leave(Player player) {
    players.where((player) => player.id() != player.id());
  }
}
