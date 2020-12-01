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

      if(responseLogin.statusCode == ConstanstVar.successCode
          || responseLogin.statusCode == ConstanstVar.invalidTokenCode
          || responseLogin.statusCode == ConstanstVar.failedHttp){
        print(responseLogin.body);
        return responseLogin.body;
      }else{
        throw new Exception("Error login");
      }
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

      if(responseAbsent.statusCode == ConstanstVar.successCode
          || responseAbsent.statusCode == ConstanstVar.invalidTokenCode
          || responseAbsent.statusCode == ConstanstVar.failedHttp){
          print('$responseAbsent.body');
          return responseAbsent.body;
      }else{
        throw new Exception("Error Absent");
      }
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
      if(responseClaim.statusCode == ConstanstVar.successCode
          || responseClaim.statusCode == ConstanstVar.invalidTokenCode
          || responseClaim.statusCode == ConstanstVar.failedHttp){
            print('$responseClaim.body');
            return responseClaim.body;
      }else{
        throw new Exception("Error Claim");
      }
    }

    Future<String> getMasterClaim() async{
      String urlMasterClaim = ConstanstVar.urlApi+'MasterClaimData.php';
      print('url $urlMasterClaim');
      final http.Response responseMasterClaim = await http.get(urlMasterClaim, headers: {'Content-Type': 'application/json',});

      if(responseMasterClaim.statusCode == ConstanstVar.successCode
          || responseMasterClaim.statusCode == ConstanstVar.failedHttp){
        print('$responseMasterClaim.body');
        return responseMasterClaim.body;
      }else{
        throw new Exception("Error Master Claim");
      }
    }
}