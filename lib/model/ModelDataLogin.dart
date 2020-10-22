
class ModelDataLogin{
  String nameUser;
  String levelDesc;
  int levelId;
  String token;
  int userId;

  ModelDataLogin({this.nameUser, this.levelDesc, this.levelId = 0, this.token, this.userId = 0});

  ModelDataLogin.fromJson(Map<String, dynamic> json) {
    nameUser = json['name_user'];
    levelDesc = json['level_desc'];
    levelId = json['level_id'];
    token = json['token'];
    userId = json['user_id'];
  }

}