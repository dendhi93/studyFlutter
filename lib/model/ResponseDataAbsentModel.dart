import 'package:absent_hris/model/ResponseDtlAbsentModel.dart';

class ResponseDataAbsentModel{
  int code;
  List<ResponseDtlDataAbsentModel> responseDtlDataAbsent;

  ResponseDataAbsentModel({this.code= 0, this.responseDtlDataAbsent});

  ResponseDataAbsentModel.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    if (json['AbsentData'] != null) {
      responseDtlDataAbsent = new List<ResponseDtlDataAbsentModel>();
      json['AbsentData'].forEach((v) {
        responseDtlDataAbsent.add(new ResponseDtlDataAbsentModel.fromJson(v));
      });
    }
  }
}