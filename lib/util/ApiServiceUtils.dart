
import 'dart:convert';

import 'package:absent_hris/model/ResponseLoginModel.dart';
import 'package:absent_hris/util/ConstanstVar.dart';
import 'package:http/http.dart' as http;

class ApiServiceUtils{

    Future<ResponseLoginModel> getLogin(String un, String pass) async{
      //post using form data
      var map = new Map<String, dynamic>();
      map['username'] = un;
      map['password'] = pass;
      final http.Response responseLogin = await http.post(ConstanstVar.urlApi+"loginUser.php",
          body: map,
      );
      if(responseLogin.statusCode == 200){
          return ResponseLoginModel.fromJson(jsonDecode(responseLogin.body));
      }else{
        return null;
      }
    }
}