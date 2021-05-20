
import 'package:absent_hris/contract/BasePresenter.dart';
import 'package:absent_hris/contract/BaseView.dart';

abstract class View extends BaseView {
  showLoginError(var msg); //called when the is an error to display
  showLoginSuccess(var msg); //message displayed when login is successful
  gotoHomePage();
}


abstract class Presenter extends BasePresenter {
  doLogin(String un, String pwd);
  initIsLogin();
}
