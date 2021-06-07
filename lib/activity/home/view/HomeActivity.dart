
import 'dart:async';

import 'package:absent_hris/activity/absent_trans/view/AbsentTransActivity.dart';
import 'package:absent_hris/activity/home/contract/HomeContract.dart';
import 'package:absent_hris/activity/home/presenter/PresenterHome.dart';
import 'package:absent_hris/activity/login/view/LoginActivity.dart';
import 'package:absent_hris/activity/requestor/RequestorActivity.dart';
import 'package:absent_hris/adapter/list_absent_adapter.dart';
import 'package:absent_hris/model/MasterAbsent/GetAbsent/CustomAbsentModel.dart';
import 'package:absent_hris/model/MasterAbsent/GetAbsent/ResponseDtlAbsentModel.dart';
import 'package:absent_hris/util/HrisUtil.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

// ignore: must_be_immutable
class HomeActivity extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _HomeActivityState createState() => _HomeActivityState();
}

class _HomeActivityState extends State<HomeActivity> implements HomeActView {
  HrisUtil _hrisUtil = HrisUtil();
  DateTime _currentBackPressTime;
  int responseCode = 0;
  String stResponseMessage = "";
  String stUid = "";
  String stToken = "";
  String _userType;
  String stMAbsentIn = "-";
  String stMAbsentOut = "-";
  String stMName = "";
  List<ResponseDtlDataAbsentModel> mList = [];
  CustomAbsentModel _mCustomAbsentModel;
  var isLoading = false;
  var isVisibleFloating  = false;
  PresenterHome _presenterHome;

  @override
  void initState() {
    super.initState();
    _presenterHome = PresenterHome(this);
    _presenterHome.initHome();
    // validateConnection(context);
    _presenterHome.validateConn(context);
  }

  //view
  Widget _initListAbsent(){
    return Container(
      child: mList.length > 0  ?
      ListView.builder(
          itemCount: mList.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              child: ListAdapter(modelAbsensi: mList[index]),
              onTap: () {
                // Navigator.of(context)
                //     .push(new MaterialPageRoute<String>(builder: (context) => AbsentTransActivity(absentModel: list[index])))
                //     .then((String value) {
                //           print(value);
                //     });
                Route route = MaterialPageRoute(builder: (context) => AbsentTransActivity(absentModel: mList[index]));
                Navigator.push(context, route).then(onGoBack);
              },
            );

            // return Dismissible(
            //   onDismissed: (DismissDirection direction) {
            //     setState(() {
            //       list.removeAt(index);
            //     });
            //   },
            //   secondaryBackground: Container(
            //     child: Center(
            //       child: Text(
            //         'Delete',
            //         style: TextStyle(color: Colors.white),
            //       ),
            //     ),
            //     color: Colors.red,
            //   ),
            //   background: Container(),
            //   child: ListAdapter(modelAbsensi: list[index]),
            //   key: UniqueKey(),
            //   direction: DismissDirection.endToStart,
            //
            // );
          }
      ) : Center(child: Text('No Data Found')),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (_currentBackPressTime == null ||
        now.difference(_currentBackPressTime) > Duration(seconds: 2)) {
      _currentBackPressTime = now;
      _hrisUtil.toastMessage("please tap again to exit");
      return Future.value(false);
    }
    return SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text(
            "Absent ",
            style: new TextStyle(color: Colors.white),
          ),
          //hide left arrow
          leading: new Container(),
        ),
        body: isLoading ? Center(
          child: CircularProgressIndicator(),
        ) : _userType != "approval" ? RequestorActivity(customAbsentModel: _mCustomAbsentModel) : _initListAbsent(),
        floatingActionButton:  new Visibility(
          visible: isVisibleFloating,
          child: new FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Route route = MaterialPageRoute(builder: (context) => AbsentTransActivity(absentModel: null));
              Navigator.push(context, route).then(onGoBack);
            },
          ),
        ),
      ),
    );
  }

  //controller
  // Future<ResponseDataAbsentModel> _loadAbsent(String uId,String userToken) async{
  //   loadingBar();
  //   try{
  //     _apiServiceUtils.getDataAbsen(uId, userToken, loadingBar).then((value) => {
  //       print(jsonDecode(value)),
  //       responseCode = ResponseDataAbsentModel.fromJson(jsonDecode(value)).code,
  //       if(responseCode == ConstanstVar.successCode){
  //         mList = ResponseDataAbsentModel.fromJson(jsonDecode(value)).responseDtlDataAbsent,
  //         stMAbsentIn = mList[0].absentTime.toString(),
  //         stMName = mList[0].nameUser,
  //         _mCustomAbsentModel = CustomAbsentModel(absentIn: stMAbsentIn, absentOut: "", nameUser: stMName),
  //         if(mList.length > 1){
  //           stMAbsentOut = mList[1].absentTime.toString(),
  //           _mCustomAbsentModel = CustomAbsentModel(absentIn: stMAbsentIn, absentOut: stMAbsentOut, nameUser: stMName),
  //           }
  //       }else if(responseCode == ConstanstVar.invalidTokenCode){
  //         stResponseMessage = ErrorResponse.fromJson(jsonDecode(value)).message,
  //         _hrisStore.removeAllValues().then((isSuccess) =>{
  //           if(isSuccess){
  //             _hrisUtil.toastMessage("$stResponseMessage"),
  //             new Future.delayed(const Duration(seconds: 4), () {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(builder: (context) => LoginActivity()),
  //               );
  //             }),
  //           }
  //         }),
  //       }else{
  //         stResponseMessage = ErrorResponse.fromJson(jsonDecode(value)).message,
  //         _hrisUtil.toastMessage("$stResponseMessage")
  //       }
  //     });
  //   }catch(error){
  //     loadingBar();
  //     _hrisUtil.toastMessage("err load Absent " +error.toString());
  //   }
  //   return null;
  // }

  FutureOr onGoBack(dynamic value) {
    // validateConnection(context);
    _presenterHome.validateConn(context);
    setState(() {});
  }

  @override
  void loadingBar(){
    setState(() {isLoading = !isLoading;});
  }

  @override
  void onAlertDialog(String titleMsg, titleContent, BuildContext context)=> _hrisUtil.showNoActionDialog(titleMsg, titleContent, context);

  @override
  void toastHome(String message) => _hrisUtil.toastMessage(message);

  @override
  void backToLogin() {
    new Future.delayed(const Duration(seconds: 4), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginActivity()),
      );
    });
  }

  @override
  void visibleFloating(){
    setState(() {isVisibleFloating = !isVisibleFloating;});
  }

  @override
  void loadUIHomeRequestor(CustomAbsentModel _customAbsentModel) {
    setState(() {_mCustomAbsentModel = _customAbsentModel;});
  }

  @override
  void loadUIApproval(List<ResponseDtlDataAbsentModel> list) {
    setState(() {mList = list;});
  }

  @override
  void initUserType(String _mUserType) {
    setState(() {_userType = _mUserType;});
  }
}


