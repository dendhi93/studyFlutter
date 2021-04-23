import 'package:absent_hris/model/MasterAbsent/GetAbsent/CustomAbsentModel.dart';
import 'package:absent_hris/util/HrisStore.dart';
import 'package:absent_hris/util/HrisUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RequestorActivity extends StatefulWidget{
  final CustomAbsentModel customAbsentModel;
  RequestorActivity({Key key, @required this.customAbsentModel}) : super(key: key);


  @override
  RequestorActivityState createState() => RequestorActivityState();
}

class RequestorActivityState extends State<RequestorActivity> {
  HrisUtil _hrisUtil = HrisUtil();
  HrisStore _hrisStore = HrisStore();
  String intentAbsentIn = "";
  String intentAbsentOut = "";


  @override
  void initState() {
    super.initState();
    if(widget.customAbsentModel != null){
      intentAbsentIn = widget.customAbsentModel.absentIn;
      intentAbsentOut = widget.customAbsentModel.absentOut;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child : new Column(
            children: <Widget>[
              new Padding(padding: EdgeInsets.only(top: 10.0)),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Container(
                      width: 200,
                      height: 95,
                      color: Colors.cyanAccent,
                      child: new Column(
                        children:  <Widget>[
                          new Padding(padding: EdgeInsets.only(top: 5.0)),
                          new Text("Absent In", style: TextStyle(fontSize: 21)),
                          new Padding(padding: EdgeInsets.only(top: 25.0)),
                          new Text(intentAbsentIn, style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),

                    new Container(
                      width: 200,
                      height: 95,
                      color: Colors.cyanAccent,
                      child: new Column(
                        children:  <Widget>[
                          new Padding(padding: EdgeInsets.only(top: 5.0)),
                          new Text("Absent Out", style: TextStyle(fontSize: 21)),
                          new Padding(padding: EdgeInsets.only(top: 25.0)),
                          new Text(intentAbsentOut, style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),

                  ]
              ),
            ]
        )
    );
  }

}