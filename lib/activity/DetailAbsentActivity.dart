import 'package:absent_hris/model/ModelAbsensi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class DetailAbsentActivity extends StatefulWidget {
  final ModelAbsensi absensiModel;
  DetailAbsentActivity({Key key, @required this.absensiModel}) : super(key: key);
  @override
  _DetailAbsentActivityState createState() => _DetailAbsentActivityState();
}

class _DetailAbsentActivityState extends State<DetailAbsentActivity> {

  TextEditingController etDateAbsent = new TextEditingController();
  TextEditingController etInputTime = new TextEditingController();
  TextEditingController etLeaveTime = new TextEditingController();
  TextEditingController etAddressAbsent = new TextEditingController();

  @override
  void initState() {
    super.initState();
    etDateAbsent.text = widget.absensiModel.dateAbsent;
    etInputTime.text = widget.absensiModel.timeIn;
    etLeaveTime.text = widget.absensiModel.timeOut;
    etAddressAbsent.text = widget.absensiModel.addressAbsent;
  }

  Widget _initDetail(BuildContext context){
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
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(15.0),
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
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(15.0),
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
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(15.0),
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
                  controller: etAddressAbsent,
                  decoration: new InputDecoration(
                    labelText: "Alamat",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(15.0),
                      borderSide: new BorderSide(
                      ),
                    ),
                  ),
                  validator: (val) {
                    if(val.length==0) {return "address cannot be empty";
                    }else{return null;}
                  },
                  keyboardType: TextInputType.text,
                  style: new TextStyle(
                    fontFamily: "Poppins",
                  ),
                ),
                new Padding(padding: EdgeInsets.only(top: 50.0)),
                new FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(20.0),
                  splashColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.yellow)
                  ),
                  onPressed: () {
                    return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Text(etDateAbsent.text),
                        );
                      },
                    );
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(fontSize: 20.0),
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
      body: _initDetail(context),
    );
  }
  Color hexToColor(String code) {return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);}
}