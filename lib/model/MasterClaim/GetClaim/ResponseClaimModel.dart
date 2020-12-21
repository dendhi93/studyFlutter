

import 'ResponseClaimDataModel.dart';

class ResponseClaimModel{
  int code;
  List<ResponseClaimDataModel> responseClaimDataModel;
  ResponseClaimModel({this.code, this.responseClaimDataModel});

  ResponseClaimModel.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    if (json['ClaimData'] != null) {
      responseClaimDataModel = new List<ResponseClaimDataModel>();
      json['ClaimData'].forEach((v) {
        responseClaimDataModel.add(new ResponseClaimDataModel.fromJson(v));
      });
    }
  }

}