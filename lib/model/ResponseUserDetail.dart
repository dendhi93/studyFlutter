class ResponseUserDetail{
  String nameUser;
  String addressUser;
  String phoneUser;
  String emailUser;

  ResponseUserDetail({this.nameUser, this.addressUser, this.phoneUser, this.emailUser});

  ResponseUserDetail.fromJson(Map<String, dynamic> json) {
    nameUser = json['name_user'];
    addressUser = json['address_user'];
    phoneUser = json['phone_user'];
    emailUser = json['email_user'];
  }
}