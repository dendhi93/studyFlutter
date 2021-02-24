import 'dart:convert';

class ErrorResponse {
  int code;
  String message;

  ErrorResponse({this.code, this.message});

  ErrorResponse.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Code'] = this.code;
    data['message'] = this.message;
    return data;
  }

  String errResponseToJson(ErrorResponse data) {
    final jsonData = data.toJson();
    return json.encode(jsonData);
  }
}