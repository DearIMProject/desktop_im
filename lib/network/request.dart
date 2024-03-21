// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:desktop_im/log/log.dart';
import 'package:desktop_im/network/request_manager.dart';
import 'package:desktop_im/user/user_manager.dart';
import 'package:desktop_im/utils/file_utils.dart';

import 'package:dio/dio.dart';
import 'package:tuple/tuple.dart';

typedef RequestSuccessCallback = void Function(dynamic data);
typedef RequestFailureCallback = void Function(
    int code, String errorStr, dynamic data);

class RequestCallback {
  RequestSuccessCallback? successCallback;
  RequestFailureCallback? failureCallback;
  RequestCallback({this.successCallback, this.failureCallback});
}

class Request {
  String host = RequestManager().hostName();

  static final Request _instance = Request._privateConstructor();
  Request._privateConstructor();

  factory Request() {
    return _instance;
  }

  void uploadRequest(String apiName, String filePath, Map<String, dynamic> map,
      RequestCallback callback) async {
    Response response;
    Map<String, dynamic> param = <String, dynamic>{};
    param.addAll(systemParam());
    param.addAll(map);

    MultipartFile file =
        await MultipartFile.fromFile(filePath, filename: filePath);
    // Tuple2<int, int> fileWidth = await FileUtils.imageWidth(file);
    FormData formData = FormData.fromMap({"file": file});
    // param["width"] = fileWidth.item1;
    // param["height"] = fileWidth.item2;
    try {
      String address = host + apiName;
      Log.debug("address = $address");
      Log.debug("param = $param");
      response =
          await Dio().post(address, data: formData, queryParameters: param);
      Map<String, dynamic> responseMap = response.data;
      Log.debug("$responseMap");
      int code = responseMap["code"];
      if (code != 200) {
        // 返回失败内容 给出回调
        if (callback.failureCallback != null) {
          callback.failureCallback!(
              responseMap["code"], responseMap["msg"], responseMap["data"]);
        }
        //TODO: code 的处理
      } else {
        if (callback.successCallback != null) {
          dynamic data = responseMap["data"];
          callback.successCallback!(data);
          Log.debug("$data");
        }
      }
    } catch (e) {
      if (callback.failureCallback != null) {
        callback.failureCallback!(500, "server failure", {});
      }
    }
  }

  void postRequest(String apiName, Map<String, dynamic> map,
      RequestCallback callback) async {
    Response response;
    Map<String, dynamic> param = <String, dynamic>{};
    param.addAll(map);
    param.addAll(systemParam());
    try {
      FormData formData = FormData.fromMap(param);
      String address = host + apiName;
      Log.debug("address = $address");
      Log.info("param = $param");
      Dio dio = Dio();
      dio.options.headers.addAll(systemParam());
      response = await dio.post(address, data: formData);

      Map<String, dynamic> responseMap = response.data;
      // Log.debug("responMap = $responseMap");
      int code = responseMap["code"];
      if (code != 200) {
        // 返回失败内容 给出回调
        if (callback.failureCallback != null) {
          Map<String, dynamic> errorMap = responseMap["data"];
          callback.failureCallback!(
              responseMap["code"], errorMap["errorMsg"], responseMap["data"]);
        }
      } else {
        if (callback.successCallback != null) {
          Map<String, dynamic> aData = responseMap["data"] ?? {};
          callback.successCallback!(aData);
        }
      }
    } catch (e) {
      Log.warn("catch e = $e");
      if (callback.failureCallback != null) {
        callback.failureCallback!(500, "server failure", {});
      }
    }
    return null;
  }

  Map<String, dynamic> systemParam() {
    Map<String, dynamic> systemParam = <String, dynamic>{};
    systemParam["token"] = UserManager.getInstance().userToken();
    return systemParam;
  }
}
