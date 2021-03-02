class ResponseDtlDataAbsentModel{
  int userId;
  String absentType;
  String reason;
  String dateAbsent;
  String absentTime;
  String addressAbsent;
  String nameUser;

  ResponseDtlDataAbsentModel(
      {this.userId,
        this.absentType,
        this.reason,
        this.dateAbsent,
        this.absentTime,
        this.addressAbsent,
        this.nameUser});

  ResponseDtlDataAbsentModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    absentType = json['absent_type'];
    reason = json['reason'];
    dateAbsent = json['date_absent'];
    absentTime = json['absent_time'];
    addressAbsent = json['address_absent'];
    nameUser = json['name_user'];
  }
}