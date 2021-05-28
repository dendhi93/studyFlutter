import 'package:absent_hris/model/MasterAbsent/GetAbsent/CustomAbsentModel.dart';
import 'package:absent_hris/model/MasterAbsent/GetAbsent/ResponseDtlAbsentModel.dart';
import 'package:flutter/cupertino.dart';

class HomeActInteractor{
  void destroyHome(){}
  void initHome(){}
  void validateConn(BuildContext context){}
  void initUIdToken(int intType){}
}

class HomeActView{
  void loadingBar(){}
  void initUserType(String _mUserType){}
  void toastHome(String message){}
  void onAlertDialog(String titleMsg, titleContent, BuildContext context){}
  void backToLogin(){}
  void visibleFloating(){}
  void loadUIHomeRequestor(CustomAbsentModel _customAbsentModel){}
  void loadUIApproval(List<ResponseDtlDataAbsentModel> list){}
}