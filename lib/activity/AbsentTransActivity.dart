
import 'package:absent_hris/model/MasterAbsent/GetAbsent/ResponseDtlAbsentModel.dart';
import 'package:absent_hris/util/HrisUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';
import 'package:android_intent/android_intent.dart';
import 'dart:io' show Platform;


class AbsentTransActivity extends StatefulWidget {
  final ResponseDtlDataAbsentModel absentModel;
  AbsentTransActivity({Key key, @required this.absentModel}) : super(key: key);
  @override
  _AbsentTransActivityState createState() => _AbsentTransActivityState();
}

class _AbsentTransActivityState extends State<AbsentTransActivity> {
  Position _currentPosition;
  TextEditingController etDateAbsent = new TextEditingController();
  TextEditingController etInputTime = new TextEditingController();
  TextEditingController etAddressAbsent = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TimeOfDay timeOfDay = TimeOfDay.now();
  HrisUtil hrisUtil = HrisUtil();
  int intDateIn = 1;
  int intDateOut = 2;
  int _groupValue = -1;
  var isHiddenButton = true;
  var isEnableRadio = true;

  @override
  void initState() {
    super.initState();
    if(widget.absentModel != null){
      etDateAbsent.text = widget.absentModel.dateAbsent;
      etInputTime.text = widget.absentModel.absentTime;
      etAddressAbsent.text = widget.absentModel.addressAbsent;
      isHiddenButton = !isHiddenButton;
      isEnableRadio = !isEnableRadio;
      if(widget.absentModel.absentType == "Absent In"){
        _groupValue = 1;
      }else{
        _groupValue = 2;
      }
    }else{
      var selectedDate = DateTime.now();
      etInputTime.text = new DateFormat.Hm().format(selectedDate);
      etDateAbsent.text = new DateFormat('y-M-dd').format(selectedDate);
      String nameDay = hrisUtil.nameOfDay(selectedDate);
      if(nameDay == "Saturday" || nameDay == "Sunday"){
        hrisUtil.toastMessage("Today is day off");
        isHiddenButton = !isHiddenButton;
      }
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
                  enabled: false,
                  controller: etDateAbsent,
                  // onTap: (){
                  //   FocusScope.of(context).requestFocus(new FocusNode());
                  //     _selecDatePicker(context);
                  // },
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
                  enabled: false,
                  controller: etInputTime,
                  // onTap: (){
                  //   FocusScope.of(context).requestFocus(new FocusNode());
                  //   _selectTimeAbsent(context, intDateIn);
                  // },
                  decoration: new InputDecoration(
                    labelText: "Time Absent",
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
                new Padding(padding: EdgeInsets.only(top: 5.0)),
                _myRadioButton(
                    title: "Absent In",
                    value: 1,
                    onChanged: (newValue) => setState(() => _groupValue = newValue)),
                _myRadioButton(
                    title: "Absent Out",
                    value: 2,
                    onChanged: (newValue) => setState(() => _groupValue = newValue)),
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
                              if(_groupValue == -1){
                                hrisUtil.toastMessage("Please choose absent type");
                              }else{
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Text("Are you sure want to absent ? "),
                                      actions: <Widget>[
                                        FlatButton(child: Text('OK'),
                                          onPressed: (){
                                            Navigator.of(context, rootNavigator: true).pop();
                                            // Navigator.pop(context, '');
                                          },
                                        ),
                                        FlatButton(child: Text('Cancel'),
                                          onPressed: (){
                                            Navigator.of(context, rootNavigator: true).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
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
                          Navigator.pop(context, '');
                        },
                        child: Text(
                          "Cancel",
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
        title: Text('Absent'),
      ),
      body: _initDetail(context),
    );
  }
  Color hexToColor(String code) {return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);}

  // _selectTimeAbsent(BuildContext context, int optionText) async{
  //   TimeOfDay t = await showTimePicker(
  //       context: context,
  //       initialTime: timeOfDay,
  //   );
  //   if(t != null)
  //     setState(() {
  //       timeOfDay = t;
  //       int intHour = timeOfDay.hour.toInt();
  //       String stHour = "";
  //       int intMinutes = timeOfDay.minute.toInt();
  //       String stMinutes = "";
  //       if(intHour < 10){stHour = "0"+intHour.toString();}
  //       else{stHour = intHour.toString();}
  //       if(intMinutes < 10){stMinutes = "0"+intMinutes.toString();}
  //       else{stMinutes = intMinutes.toString();}
  //
  //       if(optionText == intDateIn){etInputTime.text = "$stHour:$stMinutes";
  //       }else{etLeaveTime.text = "$stHour:$stMinutes";}
  //     });
  //
  // }

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
          }
        });
      }).catchError((e) {print(e);});
    return null;
  }

  Widget _myRadioButton({String title, int value, Function onChanged}) {
    return RadioListTile(
      value: value,
      groupValue: _groupValue,
      onChanged: isEnableRadio ? onChanged : null,
      title: Text(title),
    );
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
      if(widget.absentModel ==null){etAddressAbsent.text = "${first.addressLine}";}
    }
}