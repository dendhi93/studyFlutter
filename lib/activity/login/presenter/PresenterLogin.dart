

import 'package:absent_hris/activity/login/contract/ContractLogin.dart';
import 'package:absent_hris/util/ConstanstVar.dart';
import 'package:absent_hris/util/HrisStore.dart';
import 'package:absent_hris/util/HrisUtil.dart';
import 'package:flutter/src/widgets/framework.dart';

class PresenterLogin implements LoginActivityInteractor{
  LoginActivityView view;
  PresenterLogin(this.view);
  HrisStore _hrisStore = HrisStore();

  @override
  void destroyLogin() => view = null;

  @override
  void submitLogin(String un, String pwd) {
    view?.toastLogin("coba");
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
        isConnected ? submitLogin(un, pwd) : view?.onAlertDialog(ConstanstVar.noConnectionTitle, ConstanstVar.noConnectionMessage, context)
      });
  }
}