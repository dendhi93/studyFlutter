
import 'package:absent_hris/activity/ClaimActivity.dart';
import 'package:absent_hris/activity/HomeActivity.dart';
import 'package:absent_hris/activity/UnAttendancePlanningActivity.dart';
import 'package:absent_hris/util/MessageUtil.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomMenuNavigationAdapter extends StatefulWidget {
  @override
  _BottomMenuNavigationAdapterState createState() => _BottomMenuNavigationAdapterState();
}

class _BottomMenuNavigationAdapterState extends State<BottomMenuNavigationAdapter> {
  GlobalKey _bottomNavigationKey = GlobalKey();
  MessageUtil messageUtil = MessageUtil();
  final HomeActivity _homeActivity = HomeActivity();
  final ClaimActivity _claimActivity = ClaimActivity();
  final UnAttendancePlanningActivity _attendancePlanningActivity = UnAttendancePlanningActivity();

  Widget _showPage = HomeActivity();
  Widget _selectedScreen(int intSreen){
    switch(intSreen){
      case 0 :
        return _homeActivity;
        break;
      case 1 :
        return _claimActivity;
        break;
      case 2:
        return _attendancePlanningActivity;
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key : _bottomNavigationKey, index: 0, height: 65.0,
          backgroundColor: Colors.white,
          color: Colors.blue,
          buttonBackgroundColor: Colors.transparent,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 500),
          items: <Widget>[
            Icon(Icons.home, size: 30),
            Icon(Icons.attach_money, size: 30),
            Icon(Icons.list, size: 30),
          ],
          onTap: (index) {
            setState(() {
              _showPage = _selectedScreen(index);
            });
          },
        ),
        body: Container(color: Colors.white,
              child : Center(child: _showPage)),
      );
  }
}