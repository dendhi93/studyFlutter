class ResponseDtlDataAbsent{
  int userId;
  String absentType;
  String reason;
  String dateAbsent;
  String absentTime;
  String addressAbsent;

  ResponseDtlDataAbsent(
      {this.userId,
        this.absentType,
        this.reason,
        this.dateAbsent,
        this.absentTime,
        this.addressAbsent});

  ResponseDtlDataAbsent.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    absentType = json['absent_type'];
    reason = json['reason'];
    dateAbsent = json['date_absent'];
    absentTime = json['absent_time'];
    addressAbsent = json['address_absent'];
  }
}