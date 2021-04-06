class ResponseAbsentOut {
  int code;
  String absentOut;
  String absentIn;

  ResponseAbsentOut({this.code, this.absentOut, this.absentIn});

  ResponseAbsentOut.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    absentOut = json['absent_out'];
    absentIn = json['absent_in'];
  }
}