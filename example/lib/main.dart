import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ezopen_plugin/ezopen_plugin.dart';

// 萤石云参数
String appKey = 'bd36aa16e1124925a38caa7a3bf4d7b5';
String appSecret = 'd2d1bc04b830848a90e1ffffbba65393';

String accessToken =
    'at.7n5n8xjcae9iywbwbxfq8i0i8f6aatb0-58gf3blbk1-16a0b2w-hwr0ooooo';
String deviceSerial = '630571406';
String verifyCode = '';
int cameraNo = 1;

class MyButton1 extends StatelessWidget {
  const MyButton1({
    required this.contentWidget,
    this.onTapAction,
    required this.direction,
    Key? key,
  }) : super(key: key);

  final Widget contentWidget;
  final Function? onTapAction;
  final int direction;

  @override
  Widget build(BuildContext context) {
    // GestureDetector手势识别 up 事件有时候会不触发
    // 如果手指不是在 GestureDetector widget 上抬起，那么不会触发up事件
    return Listener(
      onPointerDown: (tapDown) {
        print('MyButton was onTapDown!');
        var requestData = EZPtzRequest(
          accessToken: accessToken,
          deviceSerial: deviceSerial,
          channelNo: cameraNo,
          direction: direction,
          speed: 1,
        );
        EZOpenPlugin.ptzStart(requestData).then((res) {
          print("onTapDown $res");
        });
      },
      onPointerUp: (tapUp) {
        if (onTapAction != null) {
          onTapAction?.call('myButton was hello world');
        }
        print('MyButton was onTapUp!');
        var requestData = EZPtzRequest(
          accessToken: accessToken,
          deviceSerial: deviceSerial,
          channelNo: cameraNo,
          direction: direction,
          speed: 1,
        );
        EZOpenPlugin.ptzStop(requestData).then((res) {
          print("onTapUp $res");
        });
      },
      child: contentWidget,
    );
  }
}

class MyButton2 extends StatelessWidget {
  const MyButton2(
      {required this.contentWidget,
      this.onTapAction,
      Key? key,
      this.onTapDown,
      this.onTapUp})
      : super(key: key);

  final Widget contentWidget;
  final Function? onTapAction;
  final Function? onTapDown;
  final Function? onTapUp;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // print('MyButton was tapped!');
        if (onTapAction != null) {
          onTapAction?.call('myButton was hello world');
        }
      },
      onTapDown: (tapDown) {
        if (onTapDown != null) {
          onTapDown?.call(tapDown);
        }
      },
      onTapUp: (tapUp) {
        if (onTapUp != null) {
          onTapUp?.call(tapUp);
        }
      },
      child: contentWidget,
    );
  }
}

class MyView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyViewState();
  }

  void rowTap(int index) {}

  const MyView();
}

class _MyViewState extends State<MyView> {
  //
  String backTime = 'xx';
  int backTimeTmp = 0;
  Timer? startPlayTime;
  Timer? timeId;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
      child: Column(
        children: [
          const SizedBox(
            height: 200,
            child: EZVideoView(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MyButton2(
                onTapAction: (str) {
                  EZOpenPlugin.initSdk(appKey);
                },
                contentWidget: Container(
                  height: 50.0,
                  padding: const EdgeInsets.all(8.0),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3),
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: const Center(
                    child: Text('INIT SDK'),
                  ),
                ),
              ),
              MyButton2(
                onTapAction: (str) {
                  EZOpenPlugin.setAccessToken(accessToken);
                  EZOpenPlugin.initEZPlayer(deviceSerial, verifyCode, cameraNo);
                },
                contentWidget: Container(
                  height: 50.0,
                  padding: const EdgeInsets.all(8.0),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3),
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: const Center(
                    child: Text('初始化播放器'),
                  ),
                ),
              ),
              MyButton2(
                onTapAction: (str) {
                  EZOpenPlugin.ctrolPlay(isPlay: true);
                },
                contentWidget: Container(
                  height: 50.0,
                  padding: const EdgeInsets.all(8.0),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3),
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: const Center(
                    child: Text('开始直播'),
                  ),
                ),
              ),
              MyButton2(
                onTapAction: (str) {
                  EZOpenPlugin.ctrolPlay(isPlay: false);
                },
                contentWidget: Container(
                  height: 50.0,
                  padding: const EdgeInsets.all(8.0),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3),
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: const Center(
                    child: Text('停止直播'),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              MyButton1(
                direction: 0,
                contentWidget: Container(
                  height: 50.0,
                  padding: const EdgeInsets.all(8.0),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: const Center(
                    child: Text('云台向上'),
                  ),
                ),
              ),
              MyButton1(
                direction: 1,
                contentWidget: Container(
                  height: 50.0,
                  padding: const EdgeInsets.all(8.0),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: const Center(
                    child: Text('云台向下'),
                  ),
                ),
              ),
              MyButton1(
                direction: 2,
                contentWidget: Container(
                  height: 50.0,
                  padding: const EdgeInsets.all(8.0),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: const Center(
                    child: Text('云台向左'),
                  ),
                ),
              ),
              MyButton1(
                direction: 3,
                contentWidget: Container(
                  height: 50.0,
                  padding: const EdgeInsets.all(8.0),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: const Center(
                    child: Text('云台向右'),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              MyButton1(
                direction: 8,
                contentWidget: Container(
                  height: 50.0,
                  padding: const EdgeInsets.all(8.0),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: const Center(
                    child: Text('放大'),
                  ),
                ),
              ),
              MyButton1(
                direction: 9,
                contentWidget: Container(
                  height: 50.0,
                  padding: const EdgeInsets.all(8.0),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: const Center(
                    child: Text('缩小'),
                  ),
                ),
              ),
              MyButton1(
                direction: 10,
                contentWidget: Container(
                  height: 50.0,
                  padding: const EdgeInsets.all(8.0),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: const Center(
                    child: Text('近焦距'),
                  ),
                ),
              ),
              MyButton1(
                direction: 11,
                contentWidget: Container(
                  height: 50.0,
                  padding: const EdgeInsets.all(8.0),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: const Center(
                    child: Text('远焦距'),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              MyButton2(
                onTapAction: (str) async {
                  var request = EZVideoRequest();
                  request.cameraNo = 1;
                  request.deviceSerial = deviceSerial;
                  request.verifyCode = verifyCode;
                  request.startTime = 1630368000000;
                  request.endTime = 1630425600000;

                  EZOpenPlugin.queryPlayback(request, (data) {
                    print("hello world");
                  });
                },
                contentWidget: Container(
                  height: 50.0,
                  padding: const EdgeInsets.all(8.0),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: const Center(
                    child: Text('查询回放'),
                  ),
                ),
              ),
              MyButton2(
                onTapAction: (str) async {
                  print('MyButton was tapped!');

                  // DatePicker.showDateTimePicker(context,
                  //     // 是否展示顶部操作按钮
                  //     showTitleActions: true, onChanged: (date) {
                  //   // change事件
                  //   print('change $date');
                  // }, onConfirm: (DateTime date) async {
                  //   // 确定事件
                  //   print('confirm $date');
                  //   setState(() {
                  //     backTime = date.toString().substring(0, 19);
                  //   });
                  // },
                  //     // 当前时间
                  //     currentTime: DateTime.now(),
                  //     // 语言
                  //     locale: LocaleType.zh);
                },
                contentWidget: Container(
                  height: 50.0,
                  padding: const EdgeInsets.all(8.0),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: const Center(
                    child: Text('选择回放日期时间'),
                  ),
                ),
              ),
              Text(backTime)
            ],
          ),
          Row(
            children: [
              MyButton2(
                onTapAction: (str) async {
                  DateTime date = DateTime.parse(backTime);
                  var startTime = date.millisecondsSinceEpoch;
                  var endTime = date.millisecondsSinceEpoch + (1000 * 60 * 30);

                  var videoRequest = EZVideoRequest();
                  // videoRequest.startTime = 1630422000000;
                  // videoRequest.endTime = 1630422010000;
                  videoRequest.startTime = startTime;
                  videoRequest.endTime = endTime;
                  EZOpenPlugin.startPlayback(videoRequest);
                  getplayBackTime();
                },
                contentWidget: Container(
                  height: 50.0,
                  padding: const EdgeInsets.all(8.0),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: const Center(
                    child: Text('开始回放'),
                  ),
                ),
              ),
              MyButton2(
                onTapAction: (str) async {
                  await EZOpenPlugin.stopPlayback();
                  if (startPlayTime != null) {
                    startPlayTime?.cancel();
                  }
                },
                contentWidget: Container(
                  height: 50.0,
                  padding: const EdgeInsets.all(8.0),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: const Center(
                    child: Text('停止回放'),
                  ),
                ),
              ),
              MyButton2(
                onTapDown: (tapDown) async {
                  startPlayTime?.cancel();
                  backTimeTmp = DateTime.parse(backTime).millisecondsSinceEpoch;
                  print('当前时间 = $backTimeTmp');

                  if (timeId != null) timeId?.cancel();
                  timeId = Timer.periodic(const Duration(milliseconds: 100),
                      (timer) {
                    backTimeTmp -= 15000;
                    setState(() {
                      backTime =
                          DateTime.fromMillisecondsSinceEpoch(backTimeTmp)
                              .toString()
                              .substring(0, 19);
                    });
                  });
                },
                onTapUp: (tapUp) async {
                  if (timeId != null) {
                    timeId?.cancel();
                  }
                  print('当前时间 = $backTimeTmp');

                  await EZOpenPlugin.stopPlayback();

                  var request = EZVideoRequest();
                  request.startTime = backTimeTmp;
                  request.endTime = (request.startTime ?? 0) + (1000 * 60 * 30);
                  EZOpenPlugin.startPlayback(request);
                  getplayBackTime();
                },
                contentWidget: Container(
                  height: 50.0,
                  padding: const EdgeInsets.all(8.0),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: const Center(
                    child: Text('快退'),
                  ),
                ),
              ),
              MyButton2(
                onTapDown: (tapDown) {
                  startPlayTime?.cancel();
                  backTimeTmp = DateTime.parse(backTime).millisecondsSinceEpoch;
                  print('当前时间 = $backTimeTmp');

                  if (timeId != null) timeId?.cancel();
                  timeId = Timer.periodic(const Duration(milliseconds: 100),
                      (timer) {
                    backTimeTmp += 15000;
                    setState(() {
                      backTime =
                          DateTime.fromMillisecondsSinceEpoch(backTimeTmp)
                              .toString()
                              .substring(0, 19);
                    });
                  });
                },
                onTapUp: (tapUp) async {
                  if (timeId != null) {
                    timeId?.cancel();
                  }
                  print('当前时间 = $backTimeTmp');

                  await EZOpenPlugin.stopPlayback();

                  var request = EZVideoRequest();
                  request.startTime = backTimeTmp;
                  request.endTime = (request.startTime ?? 0) + (1000 * 60 * 30);
                  EZOpenPlugin.startPlayback(request);
                  getplayBackTime();
                },
                contentWidget: Container(
                  height: 50.0,
                  padding: const EdgeInsets.all(8.0),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: const Center(
                    child: Text('快进'),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void getplayBackTime() {
    if (Platform.isIOS) {
      return;
    }
    if (startPlayTime != null) {
      startPlayTime?.cancel();
    }
    startPlayTime = Timer.periodic(const Duration(seconds: 1), (timer) async {
      int playTime = await EZOpenPlugin.getOSDTime();
      var date = DateTime.fromMillisecondsSinceEpoch(playTime);
      setState(() {
        backTime = date.toString().substring(0, 19);
      });
    });
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(body: MyView()),
    ),
  );
}
