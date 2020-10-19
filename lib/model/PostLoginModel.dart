import 'dart:convert';

class PostLoginModel{
  String username;
  String password;

  PostLoginModel({this.username, this.password});

  Map<String, dynamic> toJson() {
    return {"id": username, "name": password};
  }

  String postLoginToJson(PostLoginModel data) {
    final jsonData = data.toJson();
    return json.encode(jsonData);
  }

}