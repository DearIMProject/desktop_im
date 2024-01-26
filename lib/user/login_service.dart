import 'package:desktop_im/network/request.dart';
import 'package:desktop_im/user/user.dart';
import 'package:desktop_im/user/user_manager.dart';

typedef SuccessCallback = void Function();

class Callback {
  SuccessCallback? successCallback;
  RequestFailureCallback? failureCallback;
  Callback({this.successCallback, this.failureCallback});
}

class LoginService {
  /// 登录
  LoginService.login(String username, String password, Callback callback) {
    Request().postRequest(
        "user/login",
        {"email": username, "password": password},
        RequestCallback(
          successCallback: (data) {
            User user = User.fromJson(data["user"]);

            UserManager.getInstance().setUser(user);
            if (callback.successCallback != null) {
              callback.successCallback!();
            }
          },
          failureCallback: (code, errorStr, data) {
            if (callback.failureCallback != null) {
              callback.failureCallback!(code, errorStr, data);
            }
          },
        ));
  }

  LoginService.autoLogin(String token) {
    Request().postRequest(
        "user/autologin",
        {"token": UserManager.getInstance().userToken()},
        RequestCallback(
          successCallback: (data) {
            ;
          },
          failureCallback: (code, errorStr, data) {
            ;
          },
        ));
  }
}