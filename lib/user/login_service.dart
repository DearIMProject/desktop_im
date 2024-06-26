import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/network/request.dart';
import 'package:desktop_im/models/user.dart';
import 'package:desktop_im/notification/notification_stream.dart';
import 'package:desktop_im/notification/notifications.dart';
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
            UserManager().setUser(user);
            NotificationStream().publish(kLoginSuccessNotification);
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

  LoginService.autoLogin(String token, Callback callback) {
    Request().postRequest(
        "user/autologin",
        {"token": UserManager().userToken()},
        RequestCallback(
          successCallback: (data) {
            User user = User.fromJson(data["user"]);
            UserManager().setUser(user);
            NotificationStream().publish(kLoginSuccessNotification);
            if (callback.successCallback != null) {
              callback.successCallback!();
            }
          },
          failureCallback: (code, errorStr, data) {
            Log.debug("failureCallback");
            UserManager().setUser(null);
            NotificationStream().publish(kLogoutSuccessNotification);
            if (callback.failureCallback != null) {
              callback.failureCallback!(code, errorStr, data);
            }
          },
        ));
  }

  LoginService.logout(String token, Callback callback) {
    Request().postRequest(
      "user/logoutToken",
      {"token": token},
      RequestCallback(
        successCallback: (data) {
          UserManager().setUser(null);
          NotificationStream().publish(kLogoutSuccessNotification);
          if (callback.successCallback != null) {
            callback.successCallback!();
          }
        },
        failureCallback: (code, errorStr, data) {
          if (callback.failureCallback != null) {
            callback.failureCallback!(code, errorStr, data);
          }
        },
      ),
    );
  }
}
