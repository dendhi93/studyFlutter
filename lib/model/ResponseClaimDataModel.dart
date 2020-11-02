class ResponseClaimDataModel{
  String claimDesc;
  String detailClaim;
  String transDate;
  int statusId;
  String statusDesc;

  ResponseClaimDataModel(
      {this.claimDesc,
        this.detailClaim,
        this.transDate,
        this.statusId,
        this.statusDesc});

  ResponseClaimDataModel.fromJson(Map<String, dynamic> json) {
    claimDesc = json['claim_desc'];
    detailClaim = json['detail_claim'];
    transDate = json['trans_date'];
    statusId = json['status_id'];
    statusDesc = json['status_desc'];
  }
}