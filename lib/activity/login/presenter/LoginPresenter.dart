import 'dart:convert';

import 'package:absent_hris/activity/login/contract/ContractLogin.dart';
import 'package:absent_hris/model/ErrorResponse.dart';
import 'package:absent_hris/model/Login/ResponseLoginModel.dart';
import 'package:absent_hris/util/ApiServiceUtils.dart';
import 'package:absent_hris/util/ConstantsVar.dart';
import 'package:absent_hris/util/HrisStore.dart';
import 'package:absent_hris/util/HrisUtil.dart';
import 'package:flutter/cupertino.dart';

class LoginPresenter implements LoginActivityInteractor{
  LoginActivityView view;
  LoginPresenter(this.view);
  HrisStore _hrisStore = HrisStore();
  ApiServiceUtils _apiServiceUtils = ApiServiceUtils();
  int responseCode = 0;
  String stToken;
  String stName;
  String uLevelId = "";
  String userType = "";
  String stResponseMessage;
  String stUId;

  @override
  void destroyLogin() => view = null;

  @override
  void submitLogin(String un, String pwd) async {
      view?.loadingBar(ConstantsVar.showLoadingBar);
      try{
        //to do execute login
        _apiServiceUtils.getLogin(un.trim(), pwd.trim()).then((value) => {
            responseCode = ResponseLoginModel.fromJson(jsonDecode(value)).code,
            view?.loadingBar(ConstantsVar.hideLoadingBar),
            if(responseCode == ConstantsVar.successCode){
              uLevelId =  ResponseLoginModel.fromJson(jsonDecode(value)).modelDataLogin.levelId.toString(),
              userType =  ResponseLoginModel.fromJson(jsonDecode(value)).modelDataLogin.userType.toString(),
              stToken = ResponseLoginModel.fromJson(jsonDecode(value)).modelDataLogin.token,
              stName = ResponseLoginModel.fromJson(jsonDecode(value)).modelDataLogin.nameUser,
              stUId = ResponseLoginModel.fromJson(jsonDecode(value)).modelDataLogin.userId.toString(),

              _hrisStore.setAuthUsername(stName, stToken,stUId, uLevelId,userType),
              view?.goToHome(),
            }else{
              stResponseMessage = ErrorResponse.fromJson(jsonDecode(value)).message,
              view?.toastLogin("$stResponseMessage")
            }
        });
      }catch(error){
        view?.loadingBar(ConstantsVar.hideLoadingBar);
        view?.toastLogin("err Login " +error.toString());
      }
  }

  @override
  void initLogin() {
    Future<String> authUn = _hrisStore.getAuthUsername();
    authUn.then((data) {
      if(data != "") view?.goToHome();
    },onError: (e) {
      view?.toastLogin(e);
    });
  }

  @override
  void validateConn(BuildContext context,String un, String pwd) {
    // implement validateConn
      HrisUtil.checkConnection().then((isConnected) => {
        isConnected ? submitLogin(un, pwd) : view?.onAlertDialog(ConstantsVar.noConnectionTitle, ConstantsVar.noConnectionMessage, context)
      });
  }
}