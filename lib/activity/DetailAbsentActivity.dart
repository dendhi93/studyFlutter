
import 'package:absent_hris/model/ModelAbsensi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:android_intent/android_intent.dart';
import 'dart:io' show Platform;


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
  DateTime selectedDate = DateTime.now();
  TimeOfDay timeOfDay = TimeOfDay.now();
  int intDateIn = 1;
  int intDateOut = 2;
  var isHiddenButton = true;

  @override
  void initState() {
    super.initState();
    if(widget.absensiModel != null){
      etDateAbsent.text = widget.absensiModel.dateAbsent;
      etInputTime.text = widget.absensiModel.timeIn;
      etLeaveTime.text = widget.absensiModel.timeOut;
      etAddressAbsent.text = widget.absensiModel.addressAbsent;
      isHiddenButton = false;
    }
    _gpsValidaton();
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
                  onTap: (){
                    FocusScope.of(context).requestFocus(new FocusNode());
                      _selecDatePicker(context);
                  },
                  decoration: new InputDecoration(
                    labelText: "Date absent",
                    contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
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
                  controller: etInputTime,
                  onTap: (){
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _selectTimeAbsent(context, intDateIn);
                  },
                  decoration: new InputDecoration(
                    labelText: "Absent In",
                    contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
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
                  onTap: (){
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _selectTimeAbsent(context, intDateOut);
                  },
                  decoration: new InputDecoration(
                    labelText: "Absen out",
                    contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
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
                new Padding(padding: EdgeInsets.only(top: 30.0)),
                new TextFormField(
                  controller: etAddressAbsent,
                  maxLines: 3,
                  decoration: new InputDecoration(
                    labelText: "Address",
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
                        isHiddenButton ? new FlatButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          disabledColor: Colors.blueGrey,
                          disabledTextColor: Colors.black,
                          padding: EdgeInsets.only(left: 50, top:20, right: 50, bottom: 20),
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
                                        content: Text("Transaction Success"),
                                        actions: <Widget>[
                                            FlatButton(child: Text('OK'),
                                                onPressed: (){
                                                    Navigator.of(context, rootNavigator: true).pop();
                                                    Navigator.pop(context, '');
                                                },
                                            ),
                                        ],
                                      );
                                    },
                                  );
                            }
                          },
                          child: Text(
                            "Save",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ) : Text(""),

                      isHiddenButton ? new FlatButton(
                        color: Colors.white,
                        textColor: Colors.black,
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.grey,
                        padding: EdgeInsets.only(left: 50, top:20, right: 50, bottom: 20),
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
                      ) : Text(""),
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

  _selecDatePicker(BuildContext context) async{
    final DateTime picked = await showDatePicker(
      context: context,
      helpText: 'Select Absent Date',
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        String selectedDateFormat = new DateFormat("yyyy-MM-dd").format(selectedDate);
        etDateAbsent.text = selectedDateFormat;
      });
  }

  _selectTimeAbsent(BuildContext context, int optionText) async{
    TimeOfDay t = await showTimePicker(
        context: context,
        initialTime: timeOfDay,
    );
    if(t != null)
      setState(() {
        timeOfDay = t;
        int intHour = timeOfDay.hour.toInt();
        String stHour = "";
        int intMinutes = timeOfDay.minute.toInt();
        String stMinutes = "";
        if(intHour < 10){stHour = "0"+intHour.toString();}
        else{stHour = intHour.toString();}
        if(intMinutes < 10){stMinutes = "0"+intMinutes.toString();}
        else{stMinutes = intMinutes.toString();}

        if(optionText == intDateIn){etInputTime.text = "$stHour:$stMinutes";
        }else{etLeaveTime.text = "$stHour:$stMinutes";}
      });

  }

  Future _gpsValidaton() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    if(!(await Geolocator().isLocationServiceEnabled())){validateAlertGps();}
    else{_getCurrentLocation(geolocator);}
  }

  Future _getCurrentLocation(Geolocator _geolocator){
    _geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((Position position) {
        setState(() {
          _currentPosition = position;
          //manifest sama info.plist hrs copas manual
          if(_currentPosition != null){
            _getAddress(position);
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
      }).catchError((e) {print(e);});
  }

  void validateAlertGps(){
    if(Platform.isAndroid){
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text("Can't get current location"),
                actions: <Widget>[
                  FlatButton(child: Text('OK'),
                    onPressed: (){
                      final AndroidIntent intent = AndroidIntent(
                          action: 'android.settings.LOCATION_SOURCE_SETTINGS');
                      intent.launch();
                      //to close alert dialog
                      Navigator.of(context, rootNavigator: true).pop();
                      _gpsValidaton();
                    },
                  )
                ],
              );
            },
          );
    }else{
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text("Can't get current location"),
                actions: <Widget>[
                  FlatButton(child: Text('OK'),
                    onPressed: (){
                      Navigator.pop(context, '');
                    },
                  )
                ],
              );
            },
          );
    }
  }

  void _getAddress(Position _position) async{
      final coordinates = new Coordinates(_position.latitude, _position.longitude);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      print("${first.featureName} : ${first.addressLine}");
      if(widget.absensiModel ==null){etAddressAbsent.text = "${first.addressLine}";}
    }
}