abstract class StreamListener {
  String key;
  dynamic _data = [];

  StreamListener(this.key);

  dynamic extractRealInfo(dynamic receivedStream);

  void update();

  dynamic data() {
    return _data;
  }

  bool isTargetListener(dynamic receivedStream) {
    if (receivedStream[key] != null) {
      _data = extractRealInfo(receivedStream);
      return true;
    }

    return false;
  }
}
