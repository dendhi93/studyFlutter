import 'dart:convert';

import 'package:absent_hris/activity/home/contract/HomeContract.dart';
import 'package:absent_hris/model/ErrorResponse.dart';
import 'package:absent_hris/model/MasterAbsent/GetAbsent/CustomAbsentModel.dart';
import 'package:absent_hris/model/MasterAbsent/GetAbsent/ResponseDataAbsentModel.dart';
import 'package:absent_hris/model/MasterAbsent/GetAbsent/ResponseDtlAbsentModel.dart';
import 'package:absent_hris/util/ApiServiceUtils.dart';
import 'package:absent_hris/util/ConstantsVar.dart';
import 'package:absent_hris/util/HrisStore.dart';
import 'package:absent_hris/util/HrisUtil.dart';

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
  List<ResponseDtlDataAbsentModel> list = [];
  CustomAbsentModel _customAbsentModel;

  @override
  void destroyHome() => view = null;

  @override
  void initHome() {
    // implement initHome
    Future<String> authUType = _hrisStore.getAuthUserLevelType();
    authUType.then((data) {
      _userType = data.trim();
      print("$_userType");
      view?.initUserType(_userType);
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
      isConnected ? initUIdToken(1) : view?.onAlertDialog(ConstantsVar.noConnectionTitle, ConstantsVar.noConnectionMessage, context)
    });
  }


  Future<ResponseDataAbsentModel> loadDataAbsent(stUid, stToken) async {
    // implement loadDataAbsent
    view?.loadingBar();
    try{
          _apiServiceUtils.getDataAbsen(stUid, stToken).then((value) => {
            print(jsonDecode(value)),
            responseCode = ResponseDataAbsentModel.fromJson(jsonDecode(value)).code,
            view?.loadingBar(),
          if(responseCode == ConstantsVar.successCode){
            list = ResponseDataAbsentModel.fromJson(jsonDecode(value)).responseDtlDataAbsent,
            view?.loadUIApproval(list),

            if(list.isNotEmpty){
                  if(list.length > 1){
                    _customAbsentModel = CustomAbsentModel(absentIn: list[0].absentTime.toString(),
                        absentOut: list[1].absentTime.toString(),
                        nameUser: list[0].nameUser)
                  }else{
                    _customAbsentModel = CustomAbsentModel(absentIn: list[0].absentTime.toString(),
                        absentOut: "",
                        nameUser: list[0].nameUser)
                  },
                  view?.loadUIHomeRequestor(_customAbsentModel),
            }else{view?.loadUIHomeRequestor(null)}

          }else if(responseCode == ConstantsVar.invalidTokenCode){
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
      print(error.toString());
    }

    return null;
  }
}