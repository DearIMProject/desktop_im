import 'package:desktop_im/models/user.dart';
import 'package:desktop_im/network/request.dart';
import 'package:desktop_im/pages/datas/im_database.dart';

typedef AddressSuccess = void Function(List<User>);

class AddressCallback {
  AddressSuccess? successCallback;
  RequestFailureCallback? failureCallback;
  AddressCallback({this.successCallback, this.failureCallback});
}

class AddressbookService {
  IMDatabase database = IMDatabase.getInstance();
  AddressbookService.getAllAddressbook(AddressCallback callback) {
    Request().postRequest(
        "addressbook/all",
        {},
        RequestCallback(
            successCallback: (data) {
              List userMap = data["list"];
              List<User> resultUsers = [];
              for (var i = 0; i < userMap.length; i++) {
                User user = User.fromJson(userMap[i]);
                database.addUser(user);
                resultUsers.add(user);
              }
              if (callback.successCallback != null) {
                callback.successCallback!(resultUsers);
              }
            },
            failureCallback: callback.failureCallback));
  }
}
