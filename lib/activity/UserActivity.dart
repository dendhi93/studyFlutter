
import 'package:absent_hris/util/ApiServiceUtils.dart';
import 'package:absent_hris/util/ConstanstVar.dart';
import 'package:absent_hris/util/HrisStore.dart';
import 'package:absent_hris/util/HrisUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserActivity extends StatefulWidget {
  @override
  _UserActivityState createState() => _UserActivityState();
}

class _UserActivityState extends State<UserActivity> {
  DateTime currentBackPressTime;
  HrisUtil _hrisUtil = HrisUtil();
  HrisStore _hrisStore = HrisStore();
  var isLoadingView = false;
  String stUid = "";
  String stToken = "";
  ApiServiceUtils _apiServiceUtils = ApiServiceUtils();
  int responseCode = 0;

  @override
  void initState() {
    super.initState();
    validateConnection(context);
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      _hrisUtil.toastMessage("please tap again to exit");
      return Future.value(false);
    }
    return SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  //view
  Widget _initUser(BuildContext context){
    return Form(
      child: new Container(
        child: new Center(
            child: new Column(
                children: <Widget>[
                  new Padding(padding: EdgeInsets.only(top: 90.0)),
                  new Image.asset('assets/images/ic_user_128.png', width: 190, height: 120,),
                  new Padding(padding: EdgeInsets.only(top: 25.0)),
                  new Text("Hris Mobile", style: TextStyle(fontSize: 18)),
                  new Padding(padding: EdgeInsets.only(top: 19.0, left: 3.0,right: 3.0)),
                  Padding(
                    padding:EdgeInsets.symmetric(horizontal:10.0),
                    child:Container(
                      height:1.4,
                      width:double.infinity,
                      color:Colors.grey,),),
                    new Padding(padding: EdgeInsets.only(top: 4.0)),
                    new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Container(
                            padding: EdgeInsets.fromLTRB(13, 5, 0, 0),
                            child: Text("Address", style: TextStyle(fontSize: 15)),
                          ),
                          new Container(
                            padding: EdgeInsets.fromLTRB(0, 5, 15, 0),
                            child: Text("xxxx", style: TextStyle(fontSize: 15)),
                          ),
                        ],
                    ),
                    new Padding(padding: EdgeInsets.only(top: 4.0)),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Container(
                          padding: EdgeInsets.fromLTRB(13, 5, 0, 0),
                          child: Text("Phone", style: TextStyle(fontSize: 15)),
                        ),
                        new Container(
                          padding: EdgeInsets.fromLTRB(0, 5, 15, 0),
                          child: Text("xxxx", style: TextStyle(fontSize: 15)),
                        ),
                      ],
                    ),
                    new Padding(padding: EdgeInsets.only(top: 4.0)),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Container(
                          padding: EdgeInsets.fromLTRB(13, 5, 0, 0),
                          child: Text("Email", style: TextStyle(fontSize: 15)),
                        ),
                        new Container(
                          padding: EdgeInsets.fromLTRB(0, 5, 15, 0),
                          child: Text("xxxx", style: TextStyle(fontSize: 15)),
                        ),
                      ],
                    ),
                  new Padding(padding: EdgeInsets.only(top: 18.0, left: 3.0,right: 3.0)),
                  Padding(
                    padding:EdgeInsets.symmetric(horizontal:10.0),
                    child:Container(
                      height:1.4,
                      width:double.infinity,
                      color:Colors.grey,),),
                  new Padding(padding: EdgeInsets.only(top: 3.0)),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new GestureDetector(
                        onTap: () {
                          _hrisUtil.toastMessage("coba");
                                  },
                        child: new Container(
                          padding: EdgeInsets.fromLTRB(13, 5, 0, 0),
                          child: Text("Sign Out", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
            ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: new Scaffold(
        body: isLoadingView ? Center(
          child: CircularProgressIndicator(),
        ) :_initUser(context),
      ),
    );
  }

  //controller
  void validateConnection(BuildContext context){
    HrisUtil.checkConnection().then((isConnected) => {
      if(isConnected){

      }else{
        loadingOption(),
        _hrisUtil.showNoActionDialog(ConstanstVar.noConnectionTitle, ConstanstVar.noConnectionMessage, context)
      }
    });
  }

  void initUIdToken(int intType){
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
        // _loadClaim(stUid, stToken);
      },onError: (e) {_hrisUtil.toastMessage(e);});
    }
  }

  void loadingOption(){
    setState(() {
      isLoadingView = !isLoadingView;
    });
  }



}