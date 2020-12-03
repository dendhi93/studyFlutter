import 'package:absent_hris/model/ResponseUserDetail.dart';

class ResponseHeadUserDetail {
  int code;
  ResponseUserDetail userDetail;

  ResponseHeadUserDetail({this.code, this.userDetail});
  ResponseHeadUserDetail.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    userDetail = json['user_detail'] != null
        ? new ResponseUserDetail.fromJson(json['user_detail'])
        : null;
  }
}