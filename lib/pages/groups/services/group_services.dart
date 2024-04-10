import 'package:desktop_im/network/request.dart';
import 'package:desktop_im/pages/datas/im_database.dart';
import 'package:desktop_im/user/login_service.dart';

class GroupCallback {
  SuccessCallback? successCallback;
  RequestFailureCallback? failureCallback;
}

class GroupServices {
  IMDatabase database = IMDatabase();

  GroupServices.createGroup(List<int> userIds, GroupCallback callback) {
    Map<String, dynamic> map = {
      "userIds": userIds,
    };
    Request().postRequest(
        "/group/create",
        map,
        RequestCallback(
          successCallback: (data) {
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
}
