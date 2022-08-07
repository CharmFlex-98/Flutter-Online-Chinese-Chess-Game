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

  void ready({required String roomID}) {
    socketClient.emit(
      "ready",
      roomID,
    );
  }
}
