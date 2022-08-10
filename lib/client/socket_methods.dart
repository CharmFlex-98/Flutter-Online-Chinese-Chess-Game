import 'package:mobile_chinese_chess/client/socket_client.dart';

class SocketMethods {
  final socketClient = SocketClient.instance().socket!;

  SocketMethods();

  void loginUser(String userName) {
    socketClient.emit("loginUser", {
      "username": userName,
    });
  }

  void createRoom() {
    socketClient.emit("createRoom");
  }

  void joinRoom(String roomID) {
    socketClient.emit("joinRoom", roomID);
  }

  void leaveRoom(String roomID) {
    socketClient.emit("leaveRoom", roomID);
  }

  void ready({required String roomID}) {
    socketClient.emit(
      "ready",
      roomID,
    );
  }

  void move(
      {required String roomID,
      required int prevX,
      required int currX,
      required int prevY,
      required int currY}) {
    socketClient.emit("move", {
      "roomID": roomID,
      "moveData": {
        "prevX": prevX,
        "currX": currX,
        "prevY": prevY,
        "currY": currY,
      }
    });
  }
}
