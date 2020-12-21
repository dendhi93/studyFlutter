class ResponseDtlMasterUnAttendance{
  String id;
  String unAttendanceDesc;

  ResponseDtlMasterUnAttendance({this.id, this.unAttendanceDesc});

  ResponseDtlMasterUnAttendance.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unAttendanceDesc = json['unAttendance_desc'];
  }
}