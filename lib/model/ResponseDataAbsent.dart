import 'package:absent_hris/model/ResponseDtlAbsent.dart';

class ResponseDataAbsent{
  int code;
  List<ResponseDtlDataAbsent> responseDtlDataAbsent;

  ResponseDataAbsent({this.code= 0, this.responseDtlDataAbsent});

  ResponseDataAbsent.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    if (json['AbsentData'] != null) {
      responseDtlDataAbsent = new List<ResponseDtlDataAbsent>();
      json['AbsentData'].forEach((v) {
        responseDtlDataAbsent.add(new ResponseDtlDataAbsent.fromJson(v));
      });
    }
  }
}