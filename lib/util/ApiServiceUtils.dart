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

    Future<String> getDataAbsen(String getuId, String stToken) async{
      //post using form data
      final http.Response responseAbsent = await http
          .get(ConstanstVar.urlApi+"MasterAbsent.php?user_id="+getuId,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$stToken',
        });
      return responseAbsent.body;
    }
}