import 'package:desktop_im/models/group.dart';
import 'package:desktop_im/network/request.dart';
import 'package:desktop_im/pages/datas/im_database.dart';
import 'package:desktop_im/user/login_service.dart';

typedef GroupSuccessCallback = void Function(Group group);

class GroupCallback {
  GroupSuccessCallback? successCallback;
  RequestFailureCallback? failureCallback;
  GroupCallback({this.successCallback, this.failureCallback});
}

class GroupServices {
  IMDatabase database = IMDatabase();

  /// 创建群组
  GroupServices.createGroup(List<int> userIds, GroupCallback callback) {
    Map<String, dynamic> map = {
      "userIds": userIds.join(','),
    };
    Request().postRequest(
        "group/create",
        map,
        RequestCallback(
          successCallback: (data) {
            if (callback.successCallback != null) {
              callback.successCallback!(data);
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
