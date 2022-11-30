class EZRecordFile {
  String? begin;
  String? cameraType;
  String? end;
  int? type;

  EZRecordFile({this.begin, this.cameraType, this.end, this.type});

  EZRecordFile.fromJson(Map<String, dynamic> json) {
    begin = json['begin'];
    cameraType = json['cameraType'];
    end = json['end'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['begin'] = begin;
    data['cameraType'] = cameraType;
    data['end'] = end;
    data['type'] = type;
    return data;
  }
}
// [{"begin":"2021-08-31T11:16:47","cameraType":"D","end":"2021-08-31T11:53:06","type":1},{"begin":"2021-08-31T11:53:06","cameraType":"D","end":"2021-08-31T12:28:44","type":1},{"begin":"2021-08-31T12:28:44","cameraType":"D","end":"2021-08-31T13:04:22","type":1},{"begin":"2021-08-31T13:04:22","cameraType":"D","end":"2021-08-31T13:40:00","type":1},{"begin":"2021-08-31T13:40:00","cameraType":"D","end":"2021-08-31T14:15:38","type":1},{"begin":"2021-08-31T14:15:38","cameraType":"D","end":"2021-08-31T14:38:34","type":1},{"begin":"2021-08-31T14:45:44","cameraType":"D","end":"2021-08-31T14:58:27","type":1},{"begin":"2021-08-31T14:58:27","cameraType":"D","end":"2021-08-31T15:34:05","type":1},{"begin":"2021-08-31T15:34:05","cameraType":"D","end":"2021-08-31T16:09:43","type":1},{"begin":"2021-08-31T16:09:43","cameraType":"D","end":"2021-08-31T16:45:21","type":1},{"begin":"2021-08-31T16:45:21","cameraType":"D","end":"2021-08-31T17:20:59","type":1},{"begin":"2021-08-31T17:20:59","cameraType":"D","end":"2021-08-31T17:56:36","type":1},{"begin":"2021-08-31T17:56:36","cameraType":"D","end":"2021-08-31T18:32:15","type":1},{"begin":"2021-08-31T18:32:15","cameraType":"D","end":"2021-08-31T19:07:52","type":1},{"begin":"2021-08-31T19:07:52","cameraType":"D","end":"2021-08-31T19:43:30","type":1},{"begin":"2021-08-31T19:43:30","cameraType":"D","end":"2021-08-31T20:19:07","type":1},{"begin":"2021-08-31T20:19:07","cameraType":"D","end":"2021-08-31T20:54:46","type":1},{"begin":"2021-08-31T20:54:46","cameraType":"D","end":"2021-08-31T21:30:26","type":1},{"begin":"2021-08-31T21:30:26","cameraType":"D","end":"2021-08-31T22:06:03","type":1},{"begin":"2021-08-31T22:06:03","cameraType":"D","end":"2021-08-31T22:41:44","type":1},{"begin":"2021-08-31T22:41:44","cameraType":"D","end":"2021-08-31T23:17:21","type":1},{"begin":"2021-08-31T23:17:21","cameraType":"D","end":"2021-08-31T23:53:01","type":1},{"begin":"2021-08-31T23:53:01","cameraType":"D","end":"2021-09-01T00:28:39","type":1}]