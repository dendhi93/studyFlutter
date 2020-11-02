
import 'package:absent_hris/util/HrisUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClaimActivity extends StatefulWidget {
  @override
  _ClaimActivityState createState() => _ClaimActivityState();
}

class _ClaimActivityState extends State<ClaimActivity> {
  DateTime currentBackPressTime;
  HrisUtil messageUtil = HrisUtil();

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
      messageUtil.toastMessage("please tap again to exit");
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

      }else{

      }
    });
  }
}