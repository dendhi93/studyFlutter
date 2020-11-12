
import 'ResponseDetailMasterClaim.dart';

class ResponseMasterClaim {
  int code;
  List<ResponseDetailMasterClaim> masterClaim;

  ResponseMasterClaim.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    if (json['master_claim'] != null) {
      masterClaim = new List<ResponseDetailMasterClaim>();
      json['master_claim'].forEach((v) {
        masterClaim.add(new ResponseDetailMasterClaim.fromJson(v));
      });
    }
  }
}