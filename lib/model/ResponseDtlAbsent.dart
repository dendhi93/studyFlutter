class ResponseDtlDataAbsent{
  int userId;
  String absentType;
  String reason;
  String dateAbsent;
  String absentTime;

  ResponseDtlDataAbsent(
      {this.userId,
        this.absentType,
        this.reason,
        this.dateAbsent,
        this.absentTime});

  ResponseDtlDataAbsent.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    absentType = json['absent_type'];
    reason = json['reason'];
    dateAbsent = json['date_absent'];
    absentTime = json['absent_time'];
  }
}