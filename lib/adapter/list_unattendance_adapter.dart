
import 'package:absent_hris/model/ResponseDtlUnAttendance.dart';
import 'package:flutter/material.dart';

class ListUnAttendanceAdapter extends StatefulWidget{
  final ResponseDtlUnAttendance responseDtlUnAttendance;
  ListUnAttendanceAdapter({this.responseDtlUnAttendance});

  @override
  ListUnAttendanceAdapterState createState() => ListUnAttendanceAdapterState();
}

class ListUnAttendanceAdapterState extends State<ListUnAttendanceAdapter> {

  @override
  Widget build(BuildContext context) {
    return Card(
        child : Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[

            ],
          ),
        )
    );
  }

}