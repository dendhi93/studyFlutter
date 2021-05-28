

import 'dart:convert';

import 'package:absent_hris/activity/home/contract/HomeContract.dart';
import 'package:absent_hris/activity/home/view/HomeActivity.dart';
import 'package:absent_hris/model/MasterAbsent/GetAbsent/ResponseDataAbsentModel.dart';
import 'package:absent_hris/util/ApiServiceUtils.dart';
import 'package:absent_hris/util/ConstanstVar.dart';
import 'package:absent_hris/util/HrisStore.dart';
import 'package:absent_hris/util/HrisUtil.dart';
import 'package:flutter/src/widgets/framework.dart';

class PresenterHome implements HomeActInteractor{
  HomeActView view;
  PresenterHome(this.view);
  HrisStore _hrisStore = HrisStore();
  String stUid = "";
  String stToken = "";
  ApiServiceUtils _apiServiceUtils = ApiServiceUtils();
  int responseCode = 0;
  String stResponseMessage = "";
  String _userType;
  String stAbsentIn = "-";
  String stAbsentOut = "-";
  String stName = "";
  List<ResponseDtlDataAbsentModel> list = [];

  @override
  void destroyHome() => view = null;

  @override
  void initHome() {
    // implement initHome
    Future<String> authUType = _hrisStore.getAuthUserLevelType();
    authUType.then((data) {
      _userType = data.trim();
      if(_userType != "approval" ) view?.visibleFloating();
    });
  }

  @override
  void initUIdToken(int intType) {
    if(intType == 1){
      Future<String> authUid = _hrisStore.getAuthUserId();
      authUid.then((data) {
        stUid = data.trim();
        initUIdToken(2);
      },onError: (e) {view?.toastHome(e);});
    }else{
      Future<String> authUToken = _hrisStore.getAuthToken();
      authUToken.then((data) {
        stToken = data.trim();
        loadDataAbsent(stUid, stToken);
      },onError: (e) { view?.toastHome(e);});
    }
  }

  @override
  void validateConn(BuildContext context) {
    // implement validateConn
    HrisUtil.checkConnection().then((isConnected) => {
      isConnected ? initUIdToken(1) : view?.onAlertDialog(ConstanstVar.noConnectionTitle, ConstanstVar.noConnectionMessage, context)
    });
  }

  @override
  void loadDataAbsent(stUid, stToken) {
    // implement loadDataAbsent
    view?.loadingBar();
    try{
          _apiServiceUtils.getDataAbsen(uId, userToken, view?.loadingBar).then((value) => {
            print(jsonDecode(value)),
            responseCode = ResponseDataAbsentModel.fromJson(jsonDecode(value)).code,
          if(responseCode == ConstanstVar.successCode){

          }else if(responseCode == ConstanstVar.invalidTokenCode){
            stResponseMessage = ErrorResponse.fromJson(jsonDecode(value)).message,
            _hrisStore.removeAllValues().then((isSuccess) =>{
                  if(isSuccess){
                    view?.toastHome("$stResponseMessage"),
                    view?.backToLogin(),
                  }
              }),
          }else{
            stResponseMessage = ErrorResponse.fromJson(jsonDecode(value)).message,
            view?.toastHome("$stResponseMessage"),
          }
      });
    }catch(error){
      view?.loadingBar();
      view?.toastHome("err load Absent " +error.toString());
    }
  }

}