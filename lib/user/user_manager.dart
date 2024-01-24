import 'package:desktop_im/user/user.dart';

class UserManager {
  static UserManager? _instance;
  User? _user;
  static UserManager? getInstance() {
    // ignore: prefer_conditional_assignment
    if (_instance == null) {
      _instance = UserManager();
      _instance!._user = User();
    }
    return _instance;
  }

  void setUser(User user) {}

  int uid() {
    if (_user != null && _user!.userId != 0) {
      return _user!.userId;
    }
    return 0;
  }
}
