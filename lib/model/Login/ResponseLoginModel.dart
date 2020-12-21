import 'file:///D:/project/flutter/lib/model/Login/ModelDataLogin.dart';

class ResponseLoginModel {
  int code;
  ModelDataLogin modelDataLogin;

  ResponseLoginModel({this.code = 0, this.modelDataLogin});

  ResponseLoginModel.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    modelDataLogin = json['Data'] != null ? new ModelDataLogin.fromJson(json['Data']) : null;
  }
}
