import 'package:absent_hris/model/ModelDataLogin.dart';

class ResponseLogin {
  int code;
  ModelDataLogin modelDataLogin;

  ResponseLogin({this.code = 0, this.modelDataLogin});

  ResponseLogin.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    modelDataLogin = json['Data'] != null ? new ModelDataLogin.fromJson(json['Data']) : null;
  }
}
