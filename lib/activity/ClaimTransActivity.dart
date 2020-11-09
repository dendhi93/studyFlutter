
import 'package:absent_hris/util/HrisUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClaimTransActivity extends StatefulWidget{

  @override
  _ClaimTransActivityState createState() => _ClaimTransActivityState();
}

class _ClaimTransActivityState extends State<ClaimTransActivity> {
  DateTime currentBackPressTime;
  HrisUtil messageUtil = HrisUtil();

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Absent'),
      ),
      body: new Center(
        child: new Text("claim trans"),
      ),
    );
  }
}