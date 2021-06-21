import 'dart:core';

import 'package:absent_hris/model/ErrorResponse.dart';
import 'package:absent_hris/model/MasterAbsent/PostAbsent/PostJsonAbsent.dart';
import 'package:absent_hris/model/MasterClaim/PostClaim/PostJsonClaimTR.dart';
import 'package:absent_hris/model/Master_UnAttendance/PostUnAttendance/PostJsonUnAttendance.dart';
import 'package:absent_hris/util/ConstantsVar.dart';
import 'package:http/http.dart' as http;

class ApiServiceUtils {
    Future<String> getLogin(String un, String pass) async{
      //post using form data
      print(ConstantsVar.urlApi+'loginUser.php');
      var map = new Map<String, dynamic>();
      map['username'] = un;
      map['password'] = pass;
      final http.Response responseLogin = await http.post(ConstantsVar.urlApi+'loginUser.php',
          body: map,
      ).timeout(Duration(seconds: 50));

      if(responseLogin.statusCode == ConstantsVar.successCode
          || responseLogin.statusCode == ConstantsVar.failedHttp){
        print(responseLogin.body);
        return responseLogin.body;
      }else{
        ErrorResponse _errResponse = ErrorResponse(code: 900,message: "Error login");
        return _errResponse.errResponseToJson(_errResponse);
        // throw new Exception("Error login");
      }
    }

    Future<String> getDataAbsen(String getuId, String getToken) async{
      String urlAbsent = ConstantsVar.urlApi +'MasterAbsent2.php?user_id=$getuId-$getToken';
      //String urlAbsent = ConstanstVar.urlApi +'MasterAbsent.php?user_id=$getuId';
      print('urlnya $urlAbsent');
      final http.Response responseAbsent = await http
          .get(urlAbsent,
        headers: {
          'Content-Type': 'application/json',
          //'Authorization': '$getToken',
        }
      ).timeout(Duration(seconds: 50),
          onTimeout: (){
          throw new Exception("time out");
      });
      if(responseAbsent.statusCode == ConstantsVar.successCode
          || responseAbsent.statusCode == ConstantsVar.invalidTokenCode
          || responseAbsent.statusCode == ConstantsVar.failedHttp){
          return responseAbsent.body;
      }else{
        ErrorResponse _errResponse = ErrorResponse(code: 900,message: "Error Absent, please contact your administrator");
        return _errResponse.errResponseToJson(_errResponse);
      }
    }

    Future<String> getDataClaim(String getuId, String getToken, loadingOption()) async{
      String urlClaim = ConstantsVar.urlApi +'MasterClaimTrans.php?user_id=$getuId-$getToken';
      print('url $urlClaim');
      final http.Response responseClaim = await http
          .get(urlClaim,
          headers: {
            'Content-Type': 'application/json',
          }
      ).timeout(Duration(seconds: 50),
          onTimeout: (){
            loadingOption();
            throw new Exception("time out");
          });
      loadingOption();
      if(responseClaim.statusCode == ConstantsVar.successCode
          || responseClaim.statusCode == ConstantsVar.invalidTokenCode
          || responseClaim.statusCode == ConstantsVar.failedHttp){
            print('$responseClaim.body');
            return responseClaim.body;
      }else{
        ErrorResponse _errResponse = ErrorResponse(code: 900,message: "Error Claim, please contact your administrator");
        return _errResponse.errResponseToJson(_errResponse);
      }
    }

    Future<String> getMasterClaim() async{
      String urlMasterClaim = ConstantsVar.urlApi+'MasterClaimData.php';
      print('url $urlMasterClaim');
      final http.Response responseMasterClaim = await http.get(urlMasterClaim,
          headers: {'Content-Type': 'application/json',}).timeout(Duration(seconds: 100));

      if(responseMasterClaim.statusCode == ConstantsVar.successCode
          || responseMasterClaim.statusCode == ConstantsVar.failedHttp){
        return responseMasterClaim.body;
      }else{
        ErrorResponse _errResponse = ErrorResponse(code: 900,message: "Error Master Claim, please contact your administrator");
        return _errResponse.errResponseToJson(_errResponse);
      }
    }

    Future<String> getDataUser(String getuId, String getToken, loadingOption()) async{
      String urlUserDtl = ConstantsVar.urlApi +'MasterUserDetail.php?user_id=$getuId-$getToken';
      print('url $urlUserDtl');
      final http.Response responseUserDtl = await http
          .get(urlUserDtl,
          headers: {
            'Content-Type': 'application/json',
          }
      ).timeout(Duration(seconds: 50));
      loadingOption();
      if(responseUserDtl.statusCode == ConstantsVar.successCode
          || responseUserDtl.statusCode == ConstantsVar.invalidTokenCode
          || responseUserDtl.statusCode == ConstantsVar.failedHttp){
        return responseUserDtl.body;
      }else{
        ErrorResponse _errResponse = ErrorResponse(code: 900,message: "Error User Detail, please contact your administrator");
        return _errResponse.errResponseToJson(_errResponse);
      }
    }

    Future<String> transLogout(String getuId, String getToken) async{
      String urlLogout = ConstantsVar.urlApi +'Logout.php?user_id=$getuId-$getToken';
      print('url $urlLogout');
      final http.Response responseLogout = await http
          .get(urlLogout,
          headers: {
            'Content-Type': 'application/json',
          }
      ).timeout(Duration(seconds: 100));
      if(responseLogout.statusCode == ConstantsVar.successCode
          || responseLogout.statusCode == ConstantsVar.failedHttp){
        return responseLogout.body;
      }else{
        // throw new Exception("Error User Detail");
        ErrorResponse _errResponse = ErrorResponse(code: 900,message: "Error Logout, please contact your administrator");
        return _errResponse.errResponseToJson(_errResponse);
      }
    }

    Future<String> getDataUnAttendance(String getuId, String getToken, loadingOption()) async{
      String urlUnAttendance = ConstantsVar.urlApi +'MasterUnattendanceTrans.php?user_id=$getuId-$getToken';
      print('url $urlUnAttendance');
      final http.Response responseUnAttendance = await http
          .get(urlUnAttendance,
          headers: {
            'Content-Type': 'application/json',
          }
      ).timeout(Duration(seconds: 50),
          onTimeout: (){
            loadingOption();
            throw new Exception("time out");
          });
      loadingOption();
      if(responseUnAttendance.statusCode == ConstantsVar.successCode
          || responseUnAttendance.statusCode == ConstantsVar.invalidTokenCode
          || responseUnAttendance.statusCode == ConstantsVar.failedHttp){
        return responseUnAttendance.body;
      }else{
        ErrorResponse _errResponse = ErrorResponse(code: 900,message: "Error get unattendance, please contact your administrator");
        return _errResponse.errResponseToJson(_errResponse);
      }
    }

    Future<String> getMasterUnAttendance() async{
      String urlMasterUnAttendance = ConstantsVar.urlApi +'MasterUnAttendanceData.php';
      print('url $urlMasterUnAttendance');
      final http.Response responseMasterUnAttendance = await http
          .get(urlMasterUnAttendance,
          headers: {
            'Content-Type': 'application/json',
          }
      ).timeout(Duration(seconds: 50));
      if(responseMasterUnAttendance.statusCode == ConstantsVar.successCode){
        return responseMasterUnAttendance.body;
      }else{
        ErrorResponse _errResponse = ErrorResponse(code: 900,message: "Error master unattendance");
        return _errResponse.errResponseToJson(_errResponse);
      }
    }

    Future<String>createAbsent(PostJsonAbsent absentData) async{
      String urlTRAbsent = ConstantsVar.urlApi +'TRAbsent.php';
      print('url $urlTRAbsent');
      final http.Response responseTrAbsent = await http
          .post(urlTRAbsent,
          headers: {'Content-Type': 'application/json',},
          body: PostJsonAbsent().absentToJson(absentData)
      ).timeout(Duration(seconds: 50));

      if(responseTrAbsent.statusCode == ConstantsVar.successCode
          || responseTrAbsent.statusCode == ConstantsVar.invalidTokenCode
          || responseTrAbsent.statusCode == ConstantsVar.failedHttp){
        return responseTrAbsent.body;
      }else{
        ErrorResponse _errResponse = ErrorResponse(code: 900,message: "Error transaction absent");
        return _errResponse.errResponseToJson(_errResponse);
      }
    }

    Future<String>postClaimTrans(PostJsonClaimTR claimData) async{
      String urlTRClaim = ConstantsVar.urlApi +'TRClaim.php';
      print('url $urlTRClaim');
      final http.Response responseTrClaim = await http
          .post(urlTRClaim,
          headers: {'Content-Type': 'application/json',},
          body: PostJsonClaimTR().postClaimToJson(claimData)
      ).timeout(Duration(seconds: 50));

      if(responseTrClaim.statusCode == ConstantsVar.successCode
          || responseTrClaim.statusCode == ConstantsVar.invalidTokenCode
          || responseTrClaim.statusCode == ConstantsVar.failedHttp){
        return responseTrClaim.body;
      }else{
        ErrorResponse _errResponse = ErrorResponse(code: 900,message: "Error transaction claim");
        return _errResponse.errResponseToJson(_errResponse);
      }
    }

    Future<String>postUnAttendanceTrans(PostJsonUnAtttendance unAttendanceData) async{
      String urlTRUnAttendance = ConstantsVar.urlApi +'TRUnAttendance.php';
      print('url $urlTRUnAttendance');
      final http.Response responseTrUnAttendance = await http
          .post(urlTRUnAttendance,
          headers: {'Content-Type': 'application/json',},
          body: PostJsonUnAtttendance().postUnAttendanceToJson(unAttendanceData)
      ).timeout(Duration(seconds: 50),
          onTimeout: (){
        print('time out master unattendance trans');
        throw new Exception("time out");
      });

      if(responseTrUnAttendance.statusCode == ConstantsVar.successCode
          || responseTrUnAttendance.statusCode == ConstantsVar.invalidTokenCode
          || responseTrUnAttendance.statusCode == ConstantsVar.failedHttp){
        return responseTrUnAttendance.body;
      }else{
        ErrorResponse _errResponse = ErrorResponse(code: 900,message: "Error transaction unattendance");
        return _errResponse.errResponseToJson(_errResponse);
      }
    }

    Future<String> getMasterAbsentOut(loadingOption()) async{
      String urlMasterAbsentOut = ConstantsVar.urlApi +'MasterAbsentOutTime.php';
      print('url $urlMasterAbsentOut');

      final http.Response responseMasterAbsentOut = await http
          .get(urlMasterAbsentOut,
          headers: {
            'Content-Type': 'application/json',
          }
      ).timeout(Duration(seconds: 50),
        onTimeout: (){
          print('time out master absent out');
          loadingOption();
          throw new Exception("time out");
        }
      );
      loadingOption();
      if(responseMasterAbsentOut.statusCode == ConstantsVar.successCode){
        return responseMasterAbsentOut.body;
      }else{
        ErrorResponse _errResponse = ErrorResponse(code: 900,message: "Error master absent out");
        return _errResponse.errResponseToJson(_errResponse);
      }
    }

}