
import 'dart:convert';

import 'package:absent_hris/model/ErrorResponse.dart';
import 'package:absent_hris/model/ResponseHeadUserDetail.dart';
import 'package:absent_hris/util/ApiServiceUtils.dart';
import 'package:absent_hris/util/ConstanstVar.dart';
import 'package:absent_hris/util/HrisStore.dart';
import 'package:absent_hris/util/HrisUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'LoginActivity.dart';

class UserActivity extends StatefulWidget {
  @override
  _UserActivityState createState() => _UserActivityState();
}

class _UserActivityState extends State<UserActivity> {
  DateTime currentBackPressTime;
  HrisUtil _hrisUtil = HrisUtil();
  HrisStore _hrisStore = HrisStore();
  var isLoadingView = false;
  String stUid = "";
  String stToken = "";
  String stResponseMessage = "";
  String stAddress = "";
  String stEmail = "";
  String stPhone = "";
  String stNameUser = "";
  ApiServiceUtils _apiServiceUtils = ApiServiceUtils();
  int responseCode = 0;

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

  //view
  Widget _initUser(BuildContext context){
    return Form(
      child: new Container(
        child: new Center(
            child: new Column(
                children: <Widget>[
                  new Padding(padding: EdgeInsets.only(top: 90.0)),
                  new Image.asset('assets/images/ic_user_128.png', width: 190, height: 120,),
                  new Padding(padding: EdgeInsets.only(top: 25.0)),
                  new Text(stNameUser, style: TextStyle(fontSize: 18)),
                  new Padding(padding: EdgeInsets.only(top: 19.0, left: 3.0,right: 3.0)),
                  Padding(
                    padding:EdgeInsets.symmetric(horizontal:10.0),
                    child:Container(
                      height:1.4,
                      width:double.infinity,
                      color:Colors.grey,),),
                    new Padding(padding: EdgeInsets.only(top: 4.0)),
                    new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Container(
                            padding: EdgeInsets.fromLTRB(13, 5, 0, 0),
                            child: Text("Address", style: TextStyle(fontSize: 15)),
                          ),
                          new Container(
                            padding: EdgeInsets.fromLTRB(0, 5, 15, 0),
                            child: Text(stAddress.trim(), style: TextStyle(fontSize: 15)),
                          ),
                        ],
                    ),
                    new Padding(padding: EdgeInsets.only(top: 4.0)),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Container(
                          padding: EdgeInsets.fromLTRB(13, 5, 0, 0),
                          child: Text("Phone", style: TextStyle(fontSize: 15)),
                        ),
                        new Container(
                          padding: EdgeInsets.fromLTRB(0, 5, 15, 0),
                          child: Text(stPhone.trim(), style: TextStyle(fontSize: 15)),
                        ),
                      ],
                    ),
                    new Padding(padding: EdgeInsets.only(top: 4.0)),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Container(
                          padding: EdgeInsets.fromLTRB(13, 5, 0, 0),
                          child: Text("Email", style: TextStyle(fontSize: 15)),
                        ),
                        new Container(
                          padding: EdgeInsets.fromLTRB(0, 5, 15, 0),
                          child: Text(stEmail.trim(), style: TextStyle(fontSize: 15)),
                        ),
                      ],
                    ),
                  new Padding(padding: EdgeInsets.only(top: 18.0, left: 3.0,right: 3.0)),
                  Padding(
                    padding:EdgeInsets.symmetric(horizontal:10.0),
                    child:Container(
                      height:1.4,
                      width:double.infinity,
                      color:Colors.grey,),),
                  new Padding(padding: EdgeInsets.only(top: 3.0)),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new GestureDetector(
                        onTap: () {showAlertDialog(context);},
                        child: new Container(
                          padding: EdgeInsets.fromLTRB(13, 5, 0, 0),
                          child: Text("Sign Out", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
            ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: new Scaffold(
        body: isLoadingView ? Center(
          child: CircularProgressIndicator(),
        ) :_initUser(context),
      ),
    );
  }

  //controller
  void validateConnection(BuildContext context){
    HrisUtil.checkConnection().then((isConnected) => {
      if(isConnected){
        initUIdToken(1)
      }else{
        loadingOption(),
        _hrisUtil.showNoActionDialog(ConstanstVar.noConnectionTitle, ConstanstVar.noConnectionMessage, context)
      }
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
        _loadDtlUser(stUid, stToken);
      },onError: (e) {_hrisUtil.toastMessage(e);});
    }
  }

  void loadingOption(){
    setState(() {
      isLoadingView = !isLoadingView;
    });
  }

  Future<ResponseHeadUserDetail> _loadDtlUser(String uId,String userToken) async{
    try{
      loadingOption();
      _apiServiceUtils.getDataUser(uId, userToken).then((value) => {
        responseCode = ResponseHeadUserDetail.fromJson(jsonDecode(value)).code,
        loadingOption(),
        if(responseCode == ConstanstVar.successCode){
          stAddress = ResponseHeadUserDetail.fromJson(jsonDecode(value)).userDetail.addressUser,
          stEmail = ResponseHeadUserDetail.fromJson(jsonDecode(value)).userDetail.emailUser,
          stPhone = ResponseHeadUserDetail.fromJson(jsonDecode(value)).userDetail.phoneUser,
          stNameUser = ResponseHeadUserDetail.fromJson(jsonDecode(value)).userDetail.nameUser,
        }else if(responseCode == ConstanstVar.invalidTokenCode){
          stResponseMessage = ErrorResponse.fromJson(jsonDecode(value)).message,
          _hrisStore.removeAllValues().then((isSuccess) =>{
            if(isSuccess){
              _hrisUtil.toastMessage("$stResponseMessage"),
              new Future.delayed(const Duration(seconds: 3), () {
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

  Future<ErrorResponse> _logOutTrans(String uId,String userToken) async{
    try{
      loadingOption();
      _apiServiceUtils.transLogout(uId, userToken).then((value) => {
        responseCode = ErrorResponse.fromJson(jsonDecode(value)).code,
        stResponseMessage = ErrorResponse.fromJson(jsonDecode(value)).message,
        loadingOption(),
        if(responseCode == ConstanstVar.successCode && stResponseMessage.contains('Success')){
          _hrisStore.removeAllValues().then((isSuccess) =>{
              if(isSuccess){
                  Navigator.of(context).pop(),
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
              }
            }),
        }else{
          _hrisUtil.toastMessage("$stResponseMessage")
        }
      });
    }catch(error){
      loadingOption();
      _hrisUtil.toastMessage("err load claim " +error.toString());
    }
    return null;
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text("OK"),
      onPressed:  () {
        Navigator.of(context).pop();
        _logOutTrans(stUid, stToken);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout Application"),
      content: Text("Are you sure want to log out this application ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}