

import 'package:absent_hris/activity/home/contract/HomeContract.dart';
import 'package:absent_hris/activity/home/view/HomeActivity.dart';
import 'package:flutter/src/widgets/framework.dart';

class PresenterHome implements HomeActInteractor{
  HomeActView view;
  PresenterHome(this.view);
  String stUid = "";
  String stToken = "";

  @override
  void destroyHome() => view = null;

  @override
  void initHome() {
    // TODO: implement initHome
  }

  @override
  void initUIdToken(int intType) {
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
        // _loadAbsent(stUid, stToken);
      },onError: (e) { view?.toastLogin(e);});
    }
  }

  @override
  void validateConn(BuildContext context, String un, String pwd) {
    // TODO: implement validateConn
  }

}