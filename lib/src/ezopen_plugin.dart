import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

import 'device_ptz_api.dart';
import 'model/ptz_request.dart';
import 'model/ptz_response.dart';
import 'model/record_file.dart';
import 'model/video_request.dart';

class EZOpenPlugin {
  static const MethodChannel _channel = MethodChannel('ezopen_plugin');

  static const _pluginChannel = MethodChannel("ezopen_plugin/plugin");

  static const BasicMessageChannel<dynamic> _messageChannel =
      BasicMessageChannel("ezopen_plugin/message", StandardMessageCodec());
  static final Map<int, Function> _callBackFuncMap = {};

  static void initMessageHandler() {
    _messageChannel.setMessageHandler((message) {
      Map<String, dynamic> data = json.decode(message);

      if (data['code'] == 'RecordFile') {
        var fileData = json.decode(data['Data']);
        if (fileData != null) {
          var recordFileList = [];
          fileData.forEach((v) {
            recordFileList.add(EZRecordFile.fromJson(v));
          });

          // DateTime moonLanding = DateTime.parse(recordFileList[0].begin);
          // var time = moonLanding.millisecondsSinceEpoch;
          if (_callBackFuncMap.containsKey(data['callBackFuncId'])) {
            try {
              var func = _callBackFuncMap.remove(data['callBackFuncId']);
              func?.call(recordFileList);
            } catch (e) {
              print('Flutter EZOpen plugin error: $e');
            }
          }
        }
      }
      return message;
    });
  }

//  *  @param appKey 账号appKey
  static Future<void> initSdk(String appKey) async {
    EZOpenPlugin.initMessageHandler();
    await _pluginChannel.invokeMethod("init_sdk", {'appKey': appKey});
    return;
  }

  static Future<void> destoryLib() async {
    await _pluginChannel.invokeMethod("destoryLib");
    return;
  }

  // 设置 accessToken
  static Future<void> setAccessToken(String accessToken) async {
    await _pluginChannel.invokeMethod("set_access_token", {
      'accessToken': accessToken,
    });
    return;
  }

  // 初始化播放器
  static Future<void> initEZPlayer(
      String deviceSerial, String verifyCode, int cameraNo) async {
    await _channel.invokeMethod("EZPlayer_init", {
      'deviceSerial': deviceSerial,
      'verifyCode': verifyCode,
      'cameraNo': cameraNo,
    });
    return;
  }

  // 释放播放器
  static Future<void> destoryPlayer() async {
    await _channel.invokeMethod("release");
    return;
  }

  /// 控制声音
  ///
  /// isOpen：true开启/false关闭
  static Future<void> ctrolSound({required bool isOpen}) async {
    await _channel.invokeMethod("sound", {'Sound': isOpen});
    return;
  }

  /// 控制播放
  ///
  /// isPlay：true播放/false暂停
  static Future<void> ctrolPlay({required bool isPlay}) async {
    String method = isPlay ? "startRealPlay" : "stopRealPlay";
    await _channel.invokeMethod(method);
    return;
  }

  /// 控制对讲
  ///
  /// isTalk：true开启/false暂停
  static Future<void> ctrolTalk({required bool isTalk}) async {
    String method = isTalk ? "startVoiceTalk" : "stopVoiceTalk";
    await _channel.invokeMethod(method);
    return;
  }

  /// 结束直播
  static Future<void> endPlay() async {
    await _channel.invokeMethod("end");
    return;
  }

  static Future<int> getOSDTime() async {
    var result = await _channel.invokeMethod("getOSDTime");
    return result;
  }

  /// 查看回放
  ///
  /// startTime & endTime
  static Future<void> startPlayback(EZVideoRequest request) async {
    await _channel.invokeMethod("startPlayback", {
      'startTime': request.startTime,
      'endTime': request.endTime,
    });
    return;
  }

  /// 停止回放
  ///
  ///
  static Future<void> stopPlayback() async {
    await _channel.invokeMethod("stopPlayback");
    return;
  }

  // 查询录制视频(只实现了android)
  static Future<void> queryPlayback(
      EZVideoRequest request, Function func) async {
    int id = DateTime.now().millisecondsSinceEpoch;
    while (_callBackFuncMap.containsKey(id)) {
      id = DateTime.now().millisecondsSinceEpoch;
    }
    _callBackFuncMap[id] = func;

    await _channel.invokeMethod("queryPlayback", {
      'callBackFuncId': id,
      'startTime': request.startTime,
      'endTime': request.endTime,
      'deviceSerial': request.deviceSerial,
      'cameraNo': request.cameraNo,
      'verifyCode': request.verifyCode,
    });
    return;
  }

  // 控制云台
  static Future<EZPtzResponse?> ptzStart(EZPtzRequest requestEntity) async {
    return await EZDevicePtzApi.devicePtzStart(requestEntity);
  }

  // 停止控制
  static Future<EZPtzResponse?> ptzStop(EZPtzRequest requestEntity) async {
    return await EZDevicePtzApi.devicePtzStop(requestEntity);
  }

  // 添加设备
  static Future<bool> deviceAdd(EZPtzRequest requestEntity) async {
    return await EZDevicePtzApi.deviceAdd(requestEntity);
  }

  static Future<bool> deviceDelete(EZPtzRequest requestEntity) async {
    return await EZDevicePtzApi.deviceDelete(requestEntity);
  }

  static Future<bool> deviceIpcAdd(EZPtzRequest requestEntity) async {
    return await EZDevicePtzApi.deviceIpcAdd(requestEntity);
  }

  static Future<bool> deviceIpcDelete(EZPtzRequest requestEntity) async {
    return await EZDevicePtzApi.deviceIpcDelete(requestEntity);
  }
}
