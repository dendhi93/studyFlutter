
class PostJsonUnAtttendance {
  String userId;
  String transDate;
  String unattendanceId;
  String noteUnattendance;
  String startDate;
  String endDate;
  int qtyDate;
  String lowerUserId;
  String transId;
  String detailDesc;
  String statusId;
  String reasonReject;

  PostJsonUnAtttendance(
      {this.userId,
        this.transDate,
        this.unattendanceId,
        this.noteUnattendance,
        this.startDate,
        this.endDate,
        this.qtyDate,
        this.lowerUserId,
        this.transId,
        this.detailDesc,
        this.statusId,
        this.reasonReject});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['trans_date'] = this.transDate;
    data['unattendance_id'] = this.unattendanceId;
    data['note_unattendance'] = this.noteUnattendance;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['qty_date'] = this.qtyDate;
    data['lower_user_id'] = this.lowerUserId;
    data['trans_id'] = this.transId;
    data['detail_desc'] = this.detailDesc;
    data['status_id'] = this.statusId;
    data['reason_reject'] = this.reasonReject;
    return data;
  }
}