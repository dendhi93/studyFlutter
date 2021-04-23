import 'package:absent_hris/model/MasterAbsent/GetAbsent/ResponseDtlAbsentModel.dart';
import 'package:absent_hris/util/HrisStore.dart';
import 'package:absent_hris/util/HrisUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RequestorActivity extends StatefulWidget{
  final ResponseDtlDataAbsentModel absentModel;
  RequestorActivity({Key key, @required this.absentModel}) : super(key: key);


  @override
  RequestorActivityState createState() => RequestorActivityState();
}

class RequestorActivityState extends State<RequestorActivity> {
  HrisUtil _hrisUtil = HrisUtil();
  HrisStore _hrisStore = HrisStore();


  @override
  void initState() {
    super.initState();
    if(widget.absentModel != null){
        print(widget.absentModel.addressAbsent[0]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child : Center(child: Text('Requestor'),
        )
    );
  }

}