class User {
  static String? _id;

  static void init(String id) {
    _id = id;
  }

  static String getUserId() {
    if (_id == null) throw Exception("user is not yet created!");

    return _id!;
  }
}
