
import 'package:absent_hris/adapter/list_claim_adapter.dart';
import 'package:absent_hris/model/ResponseClaimDataModel.dart';
import 'package:absent_hris/util/ConstanstVar.dart';
import 'package:absent_hris/util/HrisStore.dart';
import 'package:absent_hris/util/HrisUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClaimActivity extends StatefulWidget {
  @override
  _ClaimActivityState createState() => _ClaimActivityState();
}

class _ClaimActivityState extends State<ClaimActivity> {
  DateTime currentBackPressTime;
  HrisUtil hrisUtil = HrisUtil();
  var isLoading = false;
  HrisUtil _hrisUtil = HrisUtil();
  HrisStore _hrisStore = HrisStore();
  List<ResponseClaimDataModel> list = List();
  String stUid = "";
  String stToken = "";

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
      hrisUtil.toastMessage("please tap again to exit");
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
            "Claim",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        body: new Center(
            child: new Text("Claim"),
        ),
      ),
    );
  }

  void validateConnection(BuildContext context){
    HrisUtil.checkConnection().then((isConnected) => {
      if(isConnected){
        hrisUtil.snackBarMessage("Test", context)
      }else{
        disableLoading(),
        hrisUtil.snackBarMessage(ConstanstVar.noConnectionMessage, context)
      }
    });
  }

  void disableLoading(){
    setState(() {
      isLoading = false;
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
      },onError: (e) {_hrisUtil.toastMessage(e);});
    }
  }

  Widget _initListClaim(){
    return Container(
      child: list.length > 0  ?
      ListView.builder(
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              child: ListClaimdapter(responseClaimDataModel: list[index]),
              onTap: () {
                  // Navigator.push(context, MaterialPageRoute(
                  //   builder: (context) => DetailAbsentActivity(absentModel: list[index]),
                  // ),
                //);
              },
            );
          }
      ) : Center(child: Text('No Data Found')),
    );
  }
}