class ResponseClaimDataModel{
  String claimDesc;
  String detailClaim;
  String transDate;
  int statusId;
  String statusDesc;
  int paidClaim;
  String descClaim;
  String fileClaim;

  ResponseClaimDataModel(
      {this.claimDesc,
        this.detailClaim,
        this.transDate,
        this.statusId,
        this.statusDesc,
        this.paidClaim,
        this.descClaim,
      this.fileClaim});

  ResponseClaimDataModel.fromJson(Map<String, dynamic> json) {
    claimDesc = json['claim_desc'];
    detailClaim = json['detail_claim'];
    transDate = json['trans_date'];
    statusId = json['status_id'];
    statusDesc = json['status_desc'];
    paidClaim = json['paid_claim'];
    descClaim = json['desc_claim'];
    fileClaim = json['file_claim'];
  }
}