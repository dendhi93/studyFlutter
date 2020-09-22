
import 'package:absent_hris/activity/ClaimActivity.dart';
import 'package:absent_hris/activity/HomeActivity.dart';
import 'package:absent_hris/activity/UnAttendancePlanningActivity.dart';
import 'package:absent_hris/util/MessageUtil.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNavigationAdapter extends StatefulWidget {
  @override
  _BottomNavigationAdapterState createState() => _BottomNavigationAdapterState();
}

class _BottomNavigationAdapterState extends State<BottomNavigationAdapter> {
  GlobalKey _bottomNavigationKey = GlobalKey();
  MessageUtil messageUtil = MessageUtil();
  final HomeActivity _homeActivity = HomeActivity();
  final ClaimActivity _claimActivity = ClaimActivity();
  final UnAttendancePlanningActivity _attendancePlanningActivity = UnAttendancePlanningActivity();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.blueAccent,
          items: <Widget>[
            Icon(Icons.home, size: 30),
            Icon(Icons.attach_money, size: 30),
            Icon(Icons.list, size: 30),
          ],
          onTap: (index) {
            //Handle button tap
          },
        ),
        body: Container(color: Colors.blueAccent),
      );
  }
}