import 'player.dart';
import 'package:mobile_chinese_chess/client/web_socket_client.dart';

class Room {
  final int id;
  final String owner;
  List<String> players = [];

  Room({required this.id, required this.owner, required this.players});
}
