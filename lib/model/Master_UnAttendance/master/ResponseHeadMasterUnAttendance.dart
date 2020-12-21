import 'package:absent_hris/model/Master_UnAttendance/master/ResponseDtlMasterUnAttendance.dart';

class ResponseHeadMasterUnAttendance{
  int code;
  List<ResponseDtlMasterUnAttendance> masterUnAttendance;

  ResponseHeadMasterUnAttendance.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    if (json['master_unAttendance'] != null) {
      masterUnAttendance = new List<ResponseDtlMasterUnAttendance>();
      json['master_unAttendance'].forEach((v) {
        masterUnAttendance.add(new ResponseDtlMasterUnAttendance.fromJson(v));
      });
    }
  }
}