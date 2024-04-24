import 'package:desktop_im/generated/l10n.dart';
import 'package:desktop_im/models/group.dart';
import 'package:desktop_im/models/message/message.dart';
import 'package:desktop_im/models/message/message_enum.dart';
import 'package:desktop_im/network/request.dart';
import 'package:desktop_im/pages/datas/im_database.dart';
import 'package:desktop_im/tcpconnect/connect/message_factory.dart';

typedef GroupSuccessCallback = void Function(Group group);
typedef GroupListSuccessCallback = void Function(List<Group> groups);

class GroupListCallback {
  GroupListSuccessCallback? successCallback;
  RequestFailureCallback? failureCallback;
  GroupListCallback({this.successCallback, this.failureCallback});
}

class GroupCallback {
  GroupSuccessCallback? successCallback;
  RequestFailureCallback? failureCallback;
  GroupCallback({this.successCallback, this.failureCallback});
}

class GroupServices {
  IMDatabase database = IMDatabase();

  GroupServices.getGroups(GroupListCallback callback) {
    Request().postRequest(
        "group/list",
        {},
        RequestCallback(
          successCallback: (data) {
            List<dynamic> mapGroups = data["list"];
            List<Group> groups =
                mapGroups.map((e) => Group.fromJson(e)).toList();
            database.saveGroups(groups);
            if (callback.successCallback != null) {
              callback.successCallback!(groups);
            }
          },
          failureCallback: (code, errorStr, data) {
            if (callback.failureCallback != null) {
              callback.failureCallback!(code, errorStr, data);
            }
          },
        ));
  }

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
            Group group = Group.fromJson(data["group"]);
            String name = data["names"];
            database.saveGroup(group);
            Message message =
                MessageFactory.messageFromType(MessageType.LOCAL_TEXT);
            message.fromEntity = MessageEntityType.SERVER;
            message.fromId = 0;
            message.toId = group.groupId;
            message.toEntity = MessageEntityType.GROUP;
            message.content = S.current.group_init(name);
            database.addMessage(message);
            if (callback.successCallback != null) {
              callback.successCallback!(group);
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
