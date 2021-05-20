

import 'package:absent_hris/activity/login/contract/ContractLogin.dart';

class PresenterLogin implements Presenter {
    View mView;

  PresenterLogin(View v){
    v.setPresenter(this);
    mView = v;
  }

  @override
  doLogin(String un, String pwd) {
    // TODO: implement doLogin
    throw UnimplementedError();
  }

  @override
  onError(String msg) {
    // TODO: implement onError
    throw UnimplementedError();
  }

  @override
  onSuccess(payload, String msg) {
    // TODO: implement onSuccess
    throw UnimplementedError();
  }

  @override
  Future subscribe() {
    // TODO: implement subscribe
    throw UnimplementedError();
  }

  @override
  Future unsubscribe() {
    // TODO: implement unsubscribe
    throw UnimplementedError();
  }

  @override
  initIsLogin() {
    // TODO: implement initIsLogin
    throw UnimplementedError();
  }

}