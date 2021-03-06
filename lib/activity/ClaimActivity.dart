
import 'dart:async';
import 'dart:convert';

import 'package:absent_hris/activity/login/view/LoginActivity.dart';
import 'package:absent_hris/adapter/list_claim_adapter.dart';
import 'package:absent_hris/model/ErrorResponse.dart';
import 'package:absent_hris/model/MasterClaim/GetClaim/ResponseClaimDataModel.dart';
import 'package:absent_hris/model/MasterClaim/GetClaim/ResponseClaimModel.dart';
import 'package:absent_hris/util/ApiServiceUtils.dart';
import 'package:absent_hris/util/ConstantsVar.dart';
import 'package:absent_hris/util/HrisStore.dart';
import 'package:absent_hris/util/HrisUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ClaimTransActivity.dart';

class ClaimActivity extends StatefulWidget {
  @override
  _ClaimActivityState createState() => _ClaimActivityState();
}

class _ClaimActivityState extends State<ClaimActivity> {
  DateTime currentBackPressTime;
  var isLoading = false;
  HrisUtil _hrisUtil = HrisUtil();
  HrisStore _hrisStore = HrisStore();
  List<ResponseClaimDataModel> listClaim = [];
  String stUid = "";
  String stToken = "";
  String _userType = "";
  var isVisibleFloating  = false;
  String stResponseMessage;
  ApiServiceUtils _apiServiceUtils = ApiServiceUtils();
  int responseCode = 0;

  @override
  void initState() {
    super.initState();
    Future<String> authUType = _hrisStore.getAuthUserLevelType();
    authUType.then((data) {
      _userType = data.trim();
      if(_userType != "approval" ){isVisibleFloating = !isVisibleFloating;}
    });
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
      isConnected ? initUIdToken(1) : _hrisUtil.snackBarMessage(ConstantsVar.noConnectionMessage, context)
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
        _loadClaim(stUid, stToken);
      },onError: (e) {_hrisUtil.toastMessage(e);});
    }
  }

  Widget _initListClaim(){
    return Container(
      child: listClaim.length > 0  ?
      ListView.builder(
          itemCount: listClaim.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              child: ListClaimAdapter(responseClaimDataModel: listClaim[index]),
              onTap: () {
                Route route = MaterialPageRoute(builder: (context) => ClaimTransActivity(claimModel: listClaim[index]));
                Navigator.push(context, route).then(onGoBack);
              },
            );
          }
      ) : Center(child: Text('No Data Found')),
    );
  }

  Future<ResponseClaimModel> _loadClaim(String uId,String userToken) async{
    try{
      loadingOption();
      _apiServiceUtils.getDataClaim(uId, userToken, loadingOption).then((value) => {
        print(jsonDecode(value)),
        responseCode = ResponseClaimModel.fromJson(jsonDecode(value)).code,
        if(responseCode == ConstantsVar.successCode){
          listClaim = ResponseClaimModel.fromJson(jsonDecode(value)).responseClaimDataModel,
        }else if(responseCode == ConstantsVar.invalidTokenCode){
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
      _hrisUtil.toastMessage("err load claim " +error.toString());
    }
    return null;
  }

  FutureOr onGoBack(dynamic value) {
    validateConnection(context);
    setState(() {});
  }

  //view
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text(
            "Claim",
            style: new TextStyle(color: Colors.white),
          ),
          leading: new Container(),
        ),
        body:isLoading ? Center(
          child: CircularProgressIndicator(),
        ) : _initListClaim(),
          floatingActionButton:  new Visibility(
            visible: isVisibleFloating,
            child: new FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  Route route = MaterialPageRoute(builder: (context) => ClaimTransActivity(claimModel: null));
                  Navigator.push(context, route).then(onGoBack);
                },
            ),
          ),
      ),
    );
  }
}