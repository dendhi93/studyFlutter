
import 'package:absent_hris/model/MasterAbsent/GetAbsent/ResponseDtlAbsentModel.dart';

class ResponseDataAbsentModel{
  int code;
  List<ResponseDtlDataAbsentModel> responseDtlDataAbsent;

  ResponseDataAbsentModel({this.code= 0, this.responseDtlDataAbsent});

  ResponseDataAbsentModel.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    if (json['AbsentData'] != null) {
      responseDtlDataAbsent = <ResponseDtlDataAbsentModel>[];
      json['AbsentData'].forEach((v) {
        responseDtlDataAbsent.add(new ResponseDtlDataAbsentModel.fromJson(v));
      });
    }
  }
}