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

  //view
  @override
  Widget build(BuildContext context) {
    return Container(
        child : new Column(
            children: <Widget>[
              new Padding(padding: EdgeInsets.only(top: 10.0)),
              new Image.asset('assets/images/ic_user_128.png', width: 190, height: 120,),
              new Padding(padding: EdgeInsets.only(top: 25.0)),
              new Text("Test", style: TextStyle(fontSize: 18)),
              new Padding(padding: EdgeInsets.only(top: 20.0)),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Container(
                      width: 200,
                      height: 95,
                      decoration: new BoxDecoration(
                          color: Colors.lightBlueAccent,
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(10.0),
                            topRight: const Radius.circular(10.0),
                            bottomLeft: const Radius.circular(10.0),
                            bottomRight: const Radius.circular(10.0),
                          )
                      ),
                      child: new Column(
                        children:  <Widget>[
                          new Padding(padding: EdgeInsets.only(top: 9.0)),
                          new Text("Absent In", style: TextStyle(fontSize: 21, color: Colors.white)),
                          new Padding(padding: EdgeInsets.only(top: 25.0)),
                          new Text(intentAbsentIn, style: TextStyle(fontSize: 18, color: Colors.white)),
                        ],
                      ),
                    ),

                    new Container(
                      width: 200,
                      height: 95,
                      decoration: new BoxDecoration(
                          color: Colors.lightBlueAccent,
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(10.0),
                            topRight: const Radius.circular(10.0),
                            bottomLeft: const Radius.circular(10.0),
                            bottomRight: const Radius.circular(10.0),
                          )
                      ),
                      child: new Column(
                        children:  <Widget>[
                          new Padding(padding: EdgeInsets.only(top: 9.0)),
                          new Text("Absent Out", style: TextStyle(fontSize: 21, color: Colors.white)),
                          new Padding(padding: EdgeInsets.only(top: 25.0)),
                          new Text(intentAbsentOut, style: TextStyle(fontSize: 18, color: Colors.white)),
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