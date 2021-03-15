class ResponseAbsentOut {
  int code;
  String absentOut;

  ResponseAbsentOut({this.code, this.absentOut});

  ResponseAbsentOut.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    absentOut = json['absent_out'];
  }
}