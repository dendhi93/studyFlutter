import 'package:absent_hris/model/ModelAbsensi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DetailAbsentActivity extends StatefulWidget {
  final ModelAbsensi absensiModel;
  DetailAbsentActivity({Key key, @required this.absensiModel}) : super(key: key);
  @override
  _DetailAbsentActivityState createState() => _DetailAbsentActivityState();
}

class _DetailAbsentActivityState extends State<DetailAbsentActivity> {
  Position _currentPosition;
  TextEditingController etDateAbsent = new TextEditingController();
  TextEditingController etInputTime = new TextEditingController();
  TextEditingController etLeaveTime = new TextEditingController();
  TextEditingController etAddressAbsent = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    if(widget.absensiModel != null){
      etDateAbsent.text = widget.absensiModel.dateAbsent;
      etInputTime.text = widget.absensiModel.timeIn;
      etLeaveTime.text = widget.absensiModel.timeOut;
      etAddressAbsent.text = widget.absensiModel.addressAbsent;
    }

    _getCurrentLocation();
  }

  Widget _initDetail(BuildContext context){
    return Form(
      key: _formKey,
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
                    if(val.length==0) {return "Time cannot be empty";
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
                    if(val.length==0) {return "Time cannot be empty";
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
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                        new FlatButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          disabledColor: Colors.blueGrey,
                          disabledTextColor: Colors.black,
                          padding: EdgeInsets.only(left: 70, top:20, right: 70, bottom: 20),
                          splashColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.yellow)
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()){
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(etDateAbsent.text),
                                      );
                                    },
                                  );
                            }
                          },
                          child: Text(
                            "Save",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),

                      new FlatButton(
                        color: Colors.white,
                        textColor: Colors.black,
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.grey,
                        padding: EdgeInsets.only(left: 70, top:20, right: 70, bottom: 20),
                        splashColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.grey)
                        ),
                        onPressed: () {
                          _clearText();
                        },
                        child: Text(
                          "Clear",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                  ],
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

  void _clearText() {
    etAddressAbsent.text = "";
    etDateAbsent.text = "";
    etInputTime.text = "";
    etLeaveTime.text = "";
  }

  void _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        //manifest sama info.plist hrs copas manual
        if(_currentPosition != null){
          Fluttertoast.showToast(
              msg: "LAT: ${_currentPosition.latitude}, LNG: ${_currentPosition.longitude}",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.blue,
              textColor: Colors.white,
              fontSize: 16.0
          );
        }
      });
    }).catchError((e) {
      print(e);
    });
  }
}