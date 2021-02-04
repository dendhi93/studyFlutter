import 'dart:convert';

class PostClaimTrans {
  String userId;
  String dateTrans;
  String claimId;
  String detailClaim;
  int paidClaim;
  String descClaim;
  String lowerUserId;
  String transId;
  String fileClaim;
  String statusId;
  String reasonReject;

  PostClaimTrans(
      {this.userId,
        this.dateTrans,
        this.claimId,
        this.detailClaim,
        this.paidClaim,
        this.descClaim,
        this.lowerUserId,
        this.transId,
        this.fileClaim,
        this.statusId,
        this.reasonReject});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['date_trans'] = this.dateTrans;
    data['claim_id'] = this.claimId;
    data['detail_claim'] = this.detailClaim;
    data['paid_claim'] = this.paidClaim;
    data['desc_claim'] = this.descClaim;
    data['lower_user_id'] = this.lowerUserId;
    data['trans_id'] = this.transId;
    data['file_claim'] = this.fileClaim;
    data['status_id'] = this.statusId;
    data['reason_reject'] = this.reasonReject;
    return data;
  }

  String postClaimToJson(PostClaimTrans data) {
    final jsonData = data.toJson();
    return json.encode(jsonData);
  }
}