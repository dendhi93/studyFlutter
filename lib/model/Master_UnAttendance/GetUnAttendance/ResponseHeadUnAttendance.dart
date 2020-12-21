import 'file:///D:/project/flutter/lib/model/Master_UnAttendance/GetUnAttendance/ResponseDtlUnAttendance.dart';

class ResponseHeadUnAttendance{
  int code;
  List<ResponseDtlUnAttendance> unAttendanceData;

  ResponseHeadUnAttendance({this.code, this.unAttendanceData});
  ResponseHeadUnAttendance.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    if (json['UnAttendanceData'] != null) {
      unAttendanceData = new List<ResponseDtlUnAttendance>();
      json['UnAttendanceData'].forEach((v) {
        unAttendanceData.add(new ResponseDtlUnAttendance.fromJson(v));
      });
    }
  }
}