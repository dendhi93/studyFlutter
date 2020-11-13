import 'package:absent_hris/util/ConstanstVar.dart';
import 'package:http/http.dart' as http;

class ApiServiceUtils{
    Future<String> getLogin(String un, String pass) async{
      //post using form data
      print(ConstanstVar.urlApi+'loginUser.php');
      var map = new Map<String, dynamic>();
      map['username'] = un;
      map['password'] = pass;
      final http.Response responseLogin = await http.post(ConstanstVar.urlApi+'loginUser.php',
          body: map,
      );
      return responseLogin.body;
      // if(responseLogin.statusCode == 200){
      //   return responseLogin.body;
      // }else{
      //   return responseLogin.body;
      // }
    }

    Future<String> getDataAbsen(String getuId, String getToken) async{
      String urlAbsent = ConstanstVar.urlApi +'MasterAbsent2.php?user_id=$getuId-$getToken';
      //String urlAbsent = ConstanstVar.urlApi +'MasterAbsent.php?user_id=$getuId';
      print('urlnya $urlAbsent');
      final http.Response responseAbsent = await http
          .get(urlAbsent,
        headers: {
          'Content-Type': 'application/json',
          //'Authorization': '$getToken',
        }
      );

      print('$responseAbsent.body');
      return responseAbsent.body;
    }

    Future<String> getDataClaim(String getuId, String getToken) async{
      String urlClaim = ConstanstVar.urlApi +'MasterClaimTrans.php?user_id=$getuId-$getToken';
      print('url $urlClaim');
      final http.Response responseClaim = await http
          .get(urlClaim,
          headers: {
            'Content-Type': 'application/json',
          }
      );

      print('$responseClaim.body');
      return responseClaim.body;
    }

    Future<String> getMasterClaim() async{
      String urlMasterClaim = ConstanstVar.urlApi+'MasterClaimData.php';
      print('url $urlMasterClaim');
      final http.Response responseClaim = await http
          .get(urlMasterClaim,
          headers: {
            'Content-Type': 'application/json',
          }
      );

      print('$responseClaim.body');
      return responseClaim.body;
    }
}