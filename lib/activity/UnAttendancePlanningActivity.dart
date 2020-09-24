import 'package:absent_hris/util/MessageUtil.dart';
import 'package:flutter/material.dart';

class UnAttendancePlanningActivity extends StatefulWidget {
  @override
  _UnAttendancePlanningActivityState createState() => _UnAttendancePlanningActivityState();
}

class _UnAttendancePlanningActivityState extends State<UnAttendancePlanningActivity> {
  DateTime currentBackPressTime;
  MessageUtil messageUtil = MessageUtil();

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      messageUtil.toastMessage("please tap again to exit");
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text(
            "UnAttendance Planning",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        body: new Center(
          child: new Text("UnAttendance Planning"),
        ),
      ),
    );
  }
}