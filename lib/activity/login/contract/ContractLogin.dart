import 'package:flutter/cupertino.dart';

class LoginActivityInteractor {
  void submitLogin(String un, String pwd){}
  void destroyLogin(){}
  void initLogin(){}
  void validateConn(BuildContext context,String un, String pwd){}
}

class LoginActivityView{
  void toastLogin(String message){}
  void onAlertDialog(String titleMsg, titleContent, BuildContext context){}
  void goToHome(){}
  void loadingBar(int typeLoading){}
}