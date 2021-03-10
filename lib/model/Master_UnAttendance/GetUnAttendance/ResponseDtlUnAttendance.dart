class ResponseDtlUnAttendance{
  String unattendanceDesc;
  String dtlUnattendance;
  String transDate;
  int statusId;
  String statusDesc;
  String descUnattendance;
  String startDate;
  String endDate;
  int qtyDate;
  String nameRequester;
  String lowerUserId;
  int transId;
  int mUnAttendanceId;

  ResponseDtlUnAttendance.fromJson(Map<String, dynamic> json) {
    unattendanceDesc = json['unattendance_desc'];
    dtlUnattendance = json['dtl_unattendance'];
    transDate = json['trans_date'];
    statusId = json['status_id'];
    statusDesc = json['status_desc'];
    descUnattendance = json['note_unattendance'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    qtyDate = json['qty_date'];
    nameRequester = json['name_requester'];
    lowerUserId = json['user_id'];
    transId = json['trans_id'];
    mUnAttendanceId = json['m_attendance_id'];
  }
}