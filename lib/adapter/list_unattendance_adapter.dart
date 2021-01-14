
import 'package:absent_hris/model/Master_UnAttendance/GetUnAttendance/ResponseDtlUnAttendance.dart';
import 'package:flutter/material.dart';

class ListUnAttendanceAdapter extends StatefulWidget{
  final ResponseDtlUnAttendance responseDtlUnAttendance;
  ListUnAttendanceAdapter({this.responseDtlUnAttendance});

  @override
  ListUnAttendanceAdapterState createState() => ListUnAttendanceAdapterState();
}

class ListUnAttendanceAdapterState extends State<ListUnAttendanceAdapter> {
  int statusUnAttendance = 0;
  String imageUnAttendance = "";

  @override
  void initState() {
    super.initState();
    statusUnAttendance = widget.responseDtlUnAttendance.statusId;
    if(statusUnAttendance != null){
      if(statusUnAttendance == 1){
        imageUnAttendance = "ic_sand.png";
      }else if(statusUnAttendance == 2){
        imageUnAttendance = "ic_ok_24.png";
      }else{
        imageUnAttendance = "ic_cross.png";
      }
    }else{
      statusUnAttendance = null;
      imageUnAttendance = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child : Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: new Image.asset(
                  "assets/images/"+imageUnAttendance ,
                  fit: BoxFit.cover,
                  width: 24.0,
                ),
                title: Text(widget.responseDtlUnAttendance.unattendanceDesc.trim()),
                trailing: Text(widget.responseDtlUnAttendance.nameRequester.trim()),
                subtitle: Text(widget.responseDtlUnAttendance.startDate + " - " + widget.responseDtlUnAttendance.endDate),
              )
            ],
          ),
        )
    );
  }

}