import 'package:absent_hris/model/MasterAbsent/PostAbsent/PostJsonAbsent.dart';
import 'package:absent_hris/util/ConstanstVar.dart';
import 'package:http/http.dart' as http;

class ApiServiceUtils {
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
        return responseMasterClaim.body;
      }else{
        throw new Exception("Error Master Claim");
      }
    }

    Future<String> getDataUser(String getuId, String getToken) async{
      String urlUserDtl = ConstanstVar.urlApi +'MasterUserDetail.php?user_id=$getuId-$getToken';
      print('url $urlUserDtl');
      final http.Response responseUserDtl = await http
          .get(urlUserDtl,
          headers: {
            'Content-Type': 'application/json',
          }
      );
      if(responseUserDtl.statusCode == ConstanstVar.successCode
          || responseUserDtl.statusCode == ConstanstVar.invalidTokenCode
          || responseUserDtl.statusCode == ConstanstVar.failedHttp){
        return responseUserDtl.body;
      }else{
        throw new Exception("Error User Detail");
      }
    }

    Future<String> transLogout(String getuId, String getToken) async{
      String urlLogout = ConstanstVar.urlApi +'Logout.php?user_id=$getuId-$getToken';
      print('url $urlLogout');
      final http.Response responseLogout = await http
          .get(urlLogout,
          headers: {
            'Content-Type': 'application/json',
          }
      );
      if(responseLogout.statusCode == ConstanstVar.successCode
          || responseLogout.statusCode == ConstanstVar.failedHttp){
        return responseLogout.body;
      }else{
        throw new Exception("Error User Detail");
      }
    }

    Future<String> getDataUnAttendance(String getuId, String getToken) async{
      String urlUnAttendance = ConstanstVar.urlApi +'MasterUnattendanceTrans.php?user_id=$getuId-$getToken';
      print('url $urlUnAttendance');
      final http.Response responseUnAttendance = await http
          .get(urlUnAttendance,
          headers: {
            'Content-Type': 'application/json',
          }
      );
      if(responseUnAttendance.statusCode == ConstanstVar.successCode
          || responseUnAttendance.statusCode == ConstanstVar.invalidTokenCode
          || responseUnAttendance.statusCode == ConstanstVar.failedHttp){
        return responseUnAttendance.body;
      }else{
        throw new Exception("Error get unattendance");
      }
    }

    Future<String> getMasterUnAttendance() async{
      String urlMasterUnAttendance = ConstanstVar.urlApi +'MasterUnAttendanceData.php';
      print('url $urlMasterUnAttendance');
      final http.Response responseMasterUnAttendance = await http
          .get(urlMasterUnAttendance,
          headers: {
            'Content-Type': 'application/json',
          }
      );
      if(responseMasterUnAttendance.statusCode == ConstanstVar.successCode){
        return responseMasterUnAttendance.body;
      }else{
        throw new Exception("Error master unattendance");
      }
    }

    Future<String>createAbsent(PostJsonAbsent absentData) async{
      String urlTRAbsent = ConstanstVar.urlApi +'TRAbsent.php';
      print('url $urlTRAbsent');
      final http.Response responseTrAbsent = await http
          .post(urlTRAbsent,
          headers: {'Content-Type': 'application/json',},
          body: PostJsonAbsent().absentToJson(absentData)
      );

      if(responseTrAbsent.statusCode == ConstanstVar.successCode
          || responseTrAbsent.statusCode == ConstanstVar.invalidTokenCode
          || responseTrAbsent.statusCode == ConstanstVar.failedHttp){
        return responseTrAbsent.body;
      }else{
        throw new Exception("Error transaction absent");
      }
    }

}