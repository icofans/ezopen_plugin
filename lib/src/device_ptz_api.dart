import 'dart:convert';
import 'package:dio/dio.dart';

import 'model/ptz_request.dart';
import 'model/ptz_response.dart';

// api文档： http://open.ys7.com/doc/zh/book/index/device_ptz.html#device_ptz-api1
class EZDevicePtzApi {
  /// base
  static const deviceBaseUrl = "https://open.ys7.com/api/lapp/device";

  static Future<EZPtzResponse?> devicePtzStart(
      EZPtzRequest requestEntity) async {
    FormData formData = FormData.fromMap({
      "accessToken": requestEntity.accessToken,
      "deviceSerial": requestEntity.deviceSerial,
      "channelNo": requestEntity.channelNo,
      "direction": requestEntity.direction,
      "speed": requestEntity.speed ?? 1,
    });

    try {
      Response response =
          await Dio().post("$deviceBaseUrl/ptz/start", data: formData);
      if (response.statusCode == 200) {
        print(response);
        EZPtzResponse responseData = EZPtzResponse.fromJson(response.data);
        return responseData;
        // if (Comparable.compare(responseData.code, "200") == 0) {
        //   // == 1 大于 "200"  == -1 小于 "200"
        //   return true;
        // }
      } else {
        // 失败
        return EZPtzResponse.fromJson({
          "code": response.statusCode,
          "msg": response.statusMessage,
        });
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<EZPtzResponse?> devicePtzStop(
      EZPtzRequest requestEntity) async {
    FormData formData = FormData.fromMap({
      "accessToken": requestEntity.accessToken,
      "deviceSerial": requestEntity.deviceSerial,
      "channelNo": requestEntity.channelNo,
      "direction": requestEntity.direction,
    });

    try {
      Response response =
          await Dio().post("$deviceBaseUrl/ptz/stop", data: formData);
      if (response.statusCode == 200) {
        EZPtzResponse responseData = EZPtzResponse.fromJson(response.data);
        print(response);
        return responseData;
      } else {
        // 失败
        return EZPtzResponse.fromJson({
          "code": response.statusCode,
          "msg": response.statusMessage,
        });
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<bool> deviceCapacity(EZPtzRequest requestEntity) async {
    FormData formData = FormData.fromMap({
      "accessToken": requestEntity.accessToken,
      "deviceSerial": requestEntity.deviceSerial,
    });

    try {
      Response response =
          await Dio().post("$deviceBaseUrl/capacity", data: formData);
      if (response.statusCode == 200) {
        EZPtzResponse responseData = EZPtzResponse.fromJson(response.data);
        print(response);
        if (Comparable.compare(responseData.code ?? "0", "200") == 0) {
          // == 1 大于 "200"  == -1 小于 "200"
          return true;
        }
      }
      // 失败
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> deviceAdd(EZPtzRequest requestEntity) async {
    FormData formData = FormData.fromMap({
      "accessToken": requestEntity.accessToken,
      "deviceSerial": requestEntity.deviceSerial,
      "validateCode": requestEntity.validateCode,
    });

    try {
      Response response =
          await Dio().post("$deviceBaseUrl/add", data: formData);
      if (response.statusCode == 200) {
        EZPtzResponse responseData = EZPtzResponse.fromJson(response.data);
        print(response);
        if (Comparable.compare(responseData.code ?? "0", "200") == 0) {
          // == 1 大于 "200"  == -1 小于 "200"
          return true;
        }
      }
      // 失败
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> deviceDelete(EZPtzRequest requestEntity) async {
    FormData formData = FormData.fromMap({
      "accessToken": requestEntity.accessToken,
      "deviceSerial": requestEntity.deviceSerial,
    });

    try {
      Response response =
          await Dio().post("$deviceBaseUrl/delete", data: formData);
      if (response.statusCode == 200) {
        EZPtzResponse responseData = EZPtzResponse.fromJson(response.data);
        print(response);
        if (Comparable.compare(responseData.code ?? "", "200") == 0) {
          // == 1 大于 "200"  == -1 小于 "200"
          return true;
        }
      }
      // 失败
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> deviceIpcAdd(EZPtzRequest requestEntity) async {
    FormData formData = FormData.fromMap({
      "accessToken": requestEntity.accessToken,
      "deviceSerial": requestEntity.deviceSerial,
      "ipcserial": requestEntity.deviceSerial,
      "channelNo": requestEntity.channelNo,
      "validateCode": requestEntity.validateCode,
    });

    try {
      Response response =
          await Dio().post("$deviceBaseUrl/ipc/add", data: formData);
      if (response.statusCode == 200) {
        EZPtzResponse responseData = EZPtzResponse.fromJson(response.data);
        print(response);
        if (Comparable.compare(responseData.code ?? "0", "200") == 0) {
          // == 1 大于 "200"  == -1 小于 "200"
          return true;
        }
      }
      // 失败
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> deviceIpcDelete(EZPtzRequest requestEntity) async {
    FormData formData = FormData.fromMap({
      "accessToken": requestEntity.accessToken,
      "deviceSerial": requestEntity.deviceSerial,
      "ipcserial": requestEntity.deviceSerial,
      "channelNo": requestEntity.channelNo,
      "validateCode": requestEntity.validateCode,
    });

    try {
      Response response =
          await Dio().post("$deviceBaseUrl/ipc/delete", data: formData);
      if (response.statusCode == 200) {
        EZPtzResponse responseData = EZPtzResponse.fromJson(response.data);
        print(response);
        if (Comparable.compare(responseData.code ?? "0", "200") == 0) {
          // == 1 大于 "200"  == -1 小于 "200"
          return true;
        }
      }
      // 失败
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
