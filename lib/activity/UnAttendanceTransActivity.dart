
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UnAttendanceTransActivity extends StatefulWidget {
  @override
  _UnAttendanceTransActivityState createState() => _UnAttendanceTransActivityState();
  
}

class _UnAttendanceTransActivityState extends State<UnAttendanceTransActivity> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UnAttendance Plan'),
      ),
      body: Center(
        child: Text("UnAttendance Plan"),
      )
    );
  }
}
