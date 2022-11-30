class EZVideoRequest {
  int? startTime;
  int? endTime;
  String? deviceSerial;
  String? verifyCode;
  int? cameraNo;

  EZVideoRequest(
      {this.startTime,
      this.endTime,
      this.deviceSerial,
      this.verifyCode,
      this.cameraNo});

  EZVideoRequest.fromJson(Map<String, dynamic> json) {
    startTime = json['startTime'];
    endTime = json['endTime'];
    deviceSerial = json['deviceSerial'];
    verifyCode = json['verifyCode'];
    cameraNo = json['cameraNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['deviceSerial'] = deviceSerial;
    data['verifyCode'] = verifyCode;
    data['cameraNo'] = cameraNo;
    return data;
  }
}
