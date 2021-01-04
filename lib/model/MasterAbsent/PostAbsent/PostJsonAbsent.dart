import 'dart:convert';

class PostJsonAbsent{
  String userId;
  String absentType;
  String addressAbsent;
  String reason;
  String dateAbsent;
  String absentLat;
  String absentLongitude;
  String absentTime;

  PostJsonAbsent(
      {this.userId,
        this.absentType,
        this.addressAbsent,
        this.reason,
        this.dateAbsent,
        this.absentLat,
        this.absentLongitude,
        this.absentTime}
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['absent_type'] = this.absentType;
    data['address_absent'] = this.addressAbsent;
    data['reason'] = this.reason;
    data['date_absent'] = this.dateAbsent;
    data['absent_lat'] = this.absentLat;
    data['absent_longitude'] = this.absentLongitude;
    data['absent_time'] = this.absentTime;
    return data;
  }

  String absentToJson(PostJsonAbsent data) {
    final jsonData = data.toJson();
    return json.encode(jsonData);
  }
}