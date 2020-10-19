import 'package:absent_hris/util/ConstanstVar.dart';
import 'package:http/http.dart' as http;

class ApiServiceUtils{

    Future<String> getLogin(String un, String pass) async{
      //post using form data
      var map = new Map<String, dynamic>();
      map['username'] = un;
      map['password'] = pass;
      final http.Response responseLogin = await http.post(ConstanstVar.urlApi+"loginUser.php",
          body: map,
      );
      return responseLogin.body;
      // if(responseLogin.statusCode == 200){
      //   return responseLogin.body;
      // }else{
      //   return responseLogin.body;
      // }
    }
}