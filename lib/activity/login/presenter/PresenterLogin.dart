

import 'package:absent_hris/activity/login/contract/ContractLogin.dart';
import 'package:absent_hris/util/HrisStore.dart';
import 'package:flutter/src/widgets/framework.dart';

class PresenterLogin implements LoginActivityInteractor{
  LoginActivityView view;
  PresenterLogin(this.view);
  HrisStore _hrisStore = HrisStore();

  @override
  void destroyLogin() => view = null;

  @override
  void submitLogin(String un, String pwd) {
    // TODO: implement login
  }

  @override
  void initLogin() {
    Future<String> authUn = _hrisStore.getAuthUsername();
    authUn.then((data) {
      if(data != ""){
        view?.goToHome();
      }
    },onError: (e) {
      view?.toastLogin(e);
    });
  }

  @override
  void validateConn(BuildContext context) {
    // TODO: implement validateConn
  }

}