
class ResponseDetailMasterClaim{
  String id;
  String claimDesc;

  ResponseDetailMasterClaim({this.id, this.claimDesc});

  ResponseDetailMasterClaim.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    claimDesc = json['claim_desc'];
  }
}