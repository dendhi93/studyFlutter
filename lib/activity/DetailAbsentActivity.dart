

import 'package:absent_hris/model/ModelAbsensi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailAbsentActivity extends StatelessWidget {
  final ModelAbsensi absensiModel;
  DetailAbsentActivity({Key key, @required this.absensiModel}) : super(key: key);

  Widget _initDetail(){
    TextEditingController etDateAbsent = new TextEditingController();
    TextEditingController etInputTime = new TextEditingController();
    TextEditingController etLeaveTime = new TextEditingController();
//    Scaffold.of(context).showSnackBar(SnackBar(
//      content: Text(absensiModel.dateAbsent),
//    ));
//    return Container(
//      padding: EdgeInsets.all(12.0),
//      child: Text('Flat Button'),
//    );

    return Material(
        child: new Container(
          padding: const EdgeInsets.all(10.0),
          color: Colors.white,
          child: new Container(
            child: new Center(
              child: new Column(
                children: <Widget>[
                      new Padding(padding: EdgeInsets.only(top: 10.0)),
                      new TextFormField(
                          controller: etDateAbsent,
                          decoration: new InputDecoration(
                            labelText: "Date Absent",
                            hintText: absensiModel.dateAbsent,
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(
                              ),
                            ),
                          ),
                        validator: (val) {
                          if(val.length==0) {return "Date cannot be empty";
                          }else{return null;}
                        },
                        keyboardType: TextInputType.datetime,
                        style: new TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                        new Padding(padding: EdgeInsets.only(top: 30.0)),
                        new TextFormField(
                          controller: etInputTime,
                          decoration: new InputDecoration(
                            labelText: "Absent In",
                            hintText: absensiModel.timeIn,
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(
                              ),
                            ),
                          ),
                          validator: (val) {
                            if(val.length==0) {return "Date cannot be empty";
                            }else{return null;}
                          },
                          keyboardType: TextInputType.datetime,
                          style: new TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                        new Padding(padding: EdgeInsets.only(top: 10.0)),
                        new TextFormField(
                          controller: etLeaveTime,
                          decoration: new InputDecoration(
                            labelText: "Absen Pulang",
                            hintText: absensiModel.timeOut,
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              borderSide: new BorderSide(
                              ),
                            ),
                          ),
                          validator: (val) {
                            if(val.length==0) {return "Date cannot be empty";
                            }else{return null;}
                          },
                          keyboardType: TextInputType.datetime,
                          style: new TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Absent'),
      ),
      body: _initDetail(),
    );
  }

  Color hexToColor(String code) {return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);}
}