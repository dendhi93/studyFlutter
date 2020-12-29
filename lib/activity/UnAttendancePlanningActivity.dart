import 'dart:convert';

import 'package:absent_hris/activity/UnAttendanceTransActivity.dart';
import 'package:absent_hris/adapter/list_unattendance_adapter.dart';
import 'package:absent_hris/model/ErrorResponse.dart';
import 'file:///D:/project/flutter/lib/model/Master_UnAttendance/GetUnAttendance/ResponseDtlUnAttendance.dart';
import 'file:///D:/project/flutter/lib/model/Master_UnAttendance/GetUnAttendance/ResponseHeadUnAttendance.dart';
import 'package:absent_hris/util/ApiServiceUtils.dart';
import 'package:absent_hris/util/ConstanstVar.dart';
import 'package:absent_hris/util/HrisStore.dart';
import 'package:absent_hris/util/HrisUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'LoginActivity.dart';

class UnAttendancePlanningActivity extends StatefulWidget {
  @override
  _UnAttendancePlanningActivityState createState() => _UnAttendancePlanningActivityState();
}

class _UnAttendancePlanningActivityState extends State<UnAttendancePlanningActivity> {
  DateTime currentBackPressTime;
  HrisUtil _hrisUtil = HrisUtil();
  HrisStore _hrisStore = HrisStore();
  List<ResponseDtlUnAttendance> listDataUnAttendance = List();
  String stUid = "";
  String stToken = "";
  String stResponseMessage;
  ApiServiceUtils _apiServiceUtils = ApiServiceUtils();
  var isLoading = false;
  int responseCode = 0;

  //controller
  @override
  void initState() {
    super.initState();
    validateConnection(context);
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      _hrisUtil.toastMessage("please tap again to exit");
      return Future.value(false);
    }
    return SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  void validateConnection(BuildContext context){
    HrisUtil.checkConnection().then((isConnected) => {
      if(isConnected){
        initUIdToken(1)
      }else{
        loadingOption(),
        _hrisUtil.snackBarMessage(ConstanstVar.noConnectionMessage, context)
      }
    });
  }

  void loadingOption(){
    setState(() {
      isLoading = !isLoading;
    });
  }

  void initUIdToken(int intType){
    if(intType == 1){
      Future<String> authUid = _hrisStore.getAuthUserId();
      authUid.then((data) {
        stUid = data.trim();
        initUIdToken(2);
      },onError: (e) {_hrisUtil.toastMessage(e);});
    }else{
      Future<String> authUToken = _hrisStore.getAuthToken();
      authUToken.then((data) {
        stToken = data.trim();
        _loadDataUnAttendance(stUid, stToken);
      },onError: (e) {_hrisUtil.toastMessage(e);});
    }
  }

  Future<ResponseHeadUnAttendance> _loadDataUnAttendance(String uId,String userToken) async{
    try{
      loadingOption();
      _apiServiceUtils.getDataUnAttendance(uId, userToken).then((value) => {
        responseCode = ResponseHeadUnAttendance.fromJson(jsonDecode(value)).code,
        loadingOption(),
        if(responseCode == ConstanstVar.successCode){
          listDataUnAttendance = ResponseHeadUnAttendance.fromJson(jsonDecode(value)).unAttendanceData,
        }else if(responseCode == ConstanstVar.invalidTokenCode){
          stResponseMessage = ErrorResponse.fromJson(jsonDecode(value)).message,
          _hrisStore.removeAllValues().then((isSuccess) =>{
            if(isSuccess){
              _hrisUtil.toastMessage("$stResponseMessage"),
              new Future.delayed(const Duration(seconds: 4), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginActivity()),
                );
              }),
            }
          }),
        }else{
          stResponseMessage = ErrorResponse.fromJson(jsonDecode(value)).message,
          _hrisUtil.toastMessage("$stResponseMessage")
        }
      });
    }catch(error){
      loadingOption();
      _hrisUtil.toastMessage("err load unattandance " +error.toString());
    }
    return null;
  }

  //view
  Widget _initListUnAttendance(){
    return Container(
      child: listDataUnAttendance.length > 0  ?
      ListView.builder(
          itemCount: listDataUnAttendance.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              child: ListUnAttendanceAdapter(responseDtlUnAttendance: listDataUnAttendance[index]),
              onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    // builder: (context) => ClaimTransActivity(claimModel: listClaim[index],),
                    builder: (context) => UnAttendanceTransActivity(unAttendanceModel: listDataUnAttendance[index],),
                  ),
                );
              },
            );
          }
      ) : Center(child: Text('No Data Found')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text(
            "UnAttendance Planning",
            style: new TextStyle(color: Colors.white),
          ),
          leading: new Container(),
        ),
          body:isLoading ? Center(
            child: CircularProgressIndicator(),
          ) : _initListUnAttendance(),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                // builder: (context) => ClaimTransActivity(claimModel: null),
                builder: (context) => UnAttendanceTransActivity(unAttendanceModel: null,),
              ),
            );
          },
        ),
      ),
    );
  }
}