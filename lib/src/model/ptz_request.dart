// entity
class EZPtzRequest {
  String? accessToken;
  String? deviceSerial;
  String? validateCode;
  String? ipcSerial;
  int? channelNo;
  int? direction;
  int? speed;
  int? command;
  int? index;

  EZPtzRequest(
      {this.accessToken,
      this.deviceSerial,
      this.validateCode,
      this.ipcSerial,
      this.channelNo,
      this.direction,
      this.speed,
      this.command,
      this.index});

  EZPtzRequest.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    deviceSerial = json['deviceSerial'];
    validateCode = json['validateCode'];
    ipcSerial = json['ipcSerial'];
    channelNo = json['channelNo'];
    direction = json['direction'];
    speed = json['speed'];
    command = json['command'];
    index = json['index'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessToken'] = accessToken;
    data['deviceSerial'] = deviceSerial;
    data['validateCode'] = validateCode;
    data['ipcSerial'] = this.ipcSerial;
    data['channelNo'] = this.channelNo;
    data['direction'] = this.direction;
    data['speed'] = this.speed;
    data['command'] = this.command;
    data['index'] = this.index;
    return data;
  }
}


/*
{
    "support_cloud": "1",
    "support_intelligent_track": "1",
    "support_p2p_mode": "1",
    "support_resolution": "16-9",
    "support_talk": "1",
    "video_quality_capacity": [
        {
            "streamType": "1",
            "videoLevel": "0",
            "resolution": "1",
            "videoBitRate": "5",
            "maxBitRate": "0"
        },
        {
            "streamType": "1",
            "videoLevel": "1",
            "resolution": "3",
            "videoBitRate": "9",
            "maxBitRate": "0"
        }
    ],
    "support_wifi_userId": "1",
    "support_remote_auth_randcode": "1",
    "support_upgrade": "1",
    "support_smart_wifi": "1",
    "support_ssl": "1",
    "support_weixin": "1",
    "ptz_close_scene": "1",
    "support_preset_alarm": "1",
    "support_related_device": "0",
    "support_message": "0",
    "ptz_preset": "1",
    "support_wifi": "3",
    "support_cloud_version": "1",
    "ptz_center_mirror": "1",
    "support_defence": "1",
    "ptz_top_bottom": "1",
    "support_fullscreen_ptz": "1",
    "support_defenceplan": "1",
    "support_disk": "1",
    "support_alarm_voice": "1",
    "ptz_left_right": "1",
    "support_modify_pwd": "1",
    "support_capture": "1",
    "support_privacy": "1",
    "support_encrypt": "1",
    "support_auto_offline": "1",

    "index": 1 // 设备预置点
}
 */