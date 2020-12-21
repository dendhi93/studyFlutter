
class ResponseDetailMasterClaim{
  String id;
  String claimDesc;
  int paidClaim;

  ResponseDetailMasterClaim({this.id, this.claimDesc});

  ResponseDetailMasterClaim.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    claimDesc = json['claim_desc'];
    paidClaim = json['paid_claim'];
  }
}