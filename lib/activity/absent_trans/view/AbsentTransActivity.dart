
import 'dart:convert';

import 'package:absent_hris/activity/absent_trans/contract/AbsentTransContract.dart';
import 'package:absent_hris/model/ErrorResponse.dart';
import 'package:absent_hris/model/MasterAbsent/GetAbsent/ResponseDtlAbsentModel.dart';
import 'package:absent_hris/model/MasterAbsent/PostAbsent/PostJsonAbsent.dart';
import 'package:absent_hris/model/MasterAbsentOut/ResponseAbsentOut.dart';
import 'package:absent_hris/util/ApiServiceUtils.dart';
import 'package:absent_hris/util/ConstanstVar.dart';
import 'package:absent_hris/util/HrisStore.dart';
import 'package:absent_hris/util/HrisUtil.dart';
import 'package:absent_hris/util/LoadingUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';
import 'package:android_intent/android_intent.dart';
import 'dart:io' show Platform;


class AbsentTransActivity extends StatefulWidget implements AbsentTransView {
  final ResponseDtlDataAbsentModel absentModel;
  AbsentTransActivity({Key key, @required this.absentModel}) : super(key: key);
  @override
  _AbsentTransActivityState createState() => _AbsentTransActivityState();

  @override
  void backScreen() {
    //  implement backScreen
  }

  @override
  void cantGetCoordinatAlert(BuildContext context) {
    //  implement cantGetCoordinatAlert
  }

  @override
  void getAbsentAddress(Position _position, BuildContext context) {
    //  implement getAbsentAddress
  }

  @override
  void initAbsentTrans(int typeInit) {
    //  implement initAbsentTrans
  }

  @override
  void loadingBar(int typeLoading) {
    //  implement loadingBar
  }

  @override
  void loadingUIBar() {
    //  implement loadingUIBar
  }

  @override
  void resultAddress(String finalAddress) {
    //  implement resultAddress
  }

  @override
  void snackBarMessage(String message) {
    //  implement snackBarMessage
  }

  @override
  void toastMessage(String theMessage) {
    //  implement toastMessage
  }

  @override
  void validateGps() {
    //  implement validateGps
  }
}

class _AbsentTransActivityState extends State<AbsentTransActivity> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  Position _currentPosition;
  TextEditingController etDateAbsent = new TextEditingController();
  TextEditingController etInputTime = new TextEditingController();
  TextEditingController etAddressAbsent = new TextEditingController();
  TextEditingController etReasonAbsent = new TextEditingController();
  TextEditingController etReasonDialogAbsent = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TimeOfDay timeOfDay = TimeOfDay.now();
  HrisUtil hrisUtil = HrisUtil();
  HrisStore _hrisStore = HrisStore();
  ApiServiceUtils _apiServiceUtils = ApiServiceUtils();
  String stToken = "";
  String stUid = "";
  String reasonAbsent = "";
  String stResponseMessage = "";
  String stInputTime;
  int intDateIn = 1;
  int intDateOut = 2;
  int _groupValue = -1;
  int responseCode = 0;
  var isHiddenButton = true;
  var isEnableRadio = true;
  var isShowReasonText = true;
  String stAbsentOut, stAbsentIn;
  var selectedDate;
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    validateConnection(context);
    if(widget.absentModel != null){
      etDateAbsent.text = widget.absentModel.dateAbsent;
      etInputTime.text = widget.absentModel.absentTime;
      etAddressAbsent.text = widget.absentModel.addressAbsent;
      reasonAbsent = widget.absentModel.reason;
      if(reasonAbsent == ""){isShowReasonText = !isShowReasonText;}
      isHiddenButton = !isHiddenButton;
      isEnableRadio = !isEnableRadio;

      if(widget.absentModel.absentType == "Absent In"){
        _groupValue = 1;
      }else{
        _groupValue = 2;
      }
    }else{
      _gpsValidaton(context);
      selectedDate = DateTime.now();
      stInputTime =  new DateFormat.Hms().format(selectedDate);
      etInputTime.text = stInputTime;
      etDateAbsent.text = new DateFormat('y-MM-dd').format(selectedDate);
      isShowReasonText = !isShowReasonText;
      String nameDay = hrisUtil.nameOfDay(selectedDate);
      if(nameDay == "Saturday" || nameDay == "Sunday"){
        hrisUtil.toastMessage("Today is day off");
        isHiddenButton = !isHiddenButton;
      }
    }
  }

  //controller
  Future _gpsValidaton(BuildContext context) async {
    loadingOption();
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    if(!(await Geolocator().isLocationServiceEnabled())){
      loadingOption();
      validateAlertGps();
    }
    else{_getCurrentLocation(geolocator, context);}
  }

  Future _getCurrentLocation(Geolocator _geolocator, BuildContext context){
    _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        //manifest sama info.plist hrs copas manual
        if(_currentPosition != null){
          _getAddress(position, context);
        }
        loadingOption();
      });
    }).catchError((e) {
      print(e);
      loadingOption();
    });
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
              TextButton(child: Text('OK'),
                onPressed: (){
                  final AndroidIntent intent = AndroidIntent(
                      action: 'android.settings.LOCATION_SOURCE_SETTINGS');
                  intent.launch();
                  //to close alert dialog
                  Navigator.of(context, rootNavigator: true).pop();
                  _gpsValidaton(context);
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
              TextButton(child: Text('OK'),
                onPressed: (){
                  // Navigator.pop(context, '');
                  Navigator.of(context).pop('String');
                },
              )
            ],
          );
        },
      );
    }
  }

  void _getAddress(Position _position, BuildContext context) async{
    try{
      final coordinates = new Coordinates(_position.latitude, _position.longitude);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      print("${first.featureName} : ${first.addressLine}");
      if(widget.absentModel ==null){
        etAddressAbsent.text = "${first.addressLine}";
      }
    }catch(error){
      print(error.toString());
      hrisUtil.toastMessage("please refresh address");
    }
  }

  void initUIdToken(int intType, BuildContext context){
    if(intType == 1){
      Future<String> authUid = _hrisStore.getAuthUserId();
      authUid.then((data) {
        stUid = data.trim();
        initUIdToken(2, context);
      },onError: (e) {hrisUtil.toastMessage(e);});
    }else{
      Future<String> authUToken = _hrisStore.getAuthToken();
      authUToken.then((data) {
        String _stAbsentLat = "";
        String _stAbsentLongitude = "";

        stToken = data.trim();
        stUid = stUid+"-"+stToken;
        if(_currentPosition != null){
          _stAbsentLat = _currentPosition.latitude.toString();
          _stAbsentLongitude = _currentPosition.longitude.toString();
        }
        if(etReasonDialogAbsent.text.isNotEmpty){reasonAbsent = etReasonDialogAbsent.text.toString().trim();}
        PostJsonAbsent _postJsonAbsent =
          PostJsonAbsent(userId: stUid,absentType: _groupValue.toString(),
            addressAbsent: etAddressAbsent.text.trim(),reason: reasonAbsent,
              dateAbsent: etDateAbsent.text.toString(),absentLat: _stAbsentLat,
              absentLongitude: _stAbsentLongitude, absentTime: etInputTime.text.toString());

        print(PostJsonAbsent().absentToJson(_postJsonAbsent));
        _submitAbsent(context, _postJsonAbsent);
      },onError: (e) {hrisUtil.toastMessage(e);});
    }
  }

  void validateConnectionSubmit(BuildContext context){
    // var splitStartTime;
    String stFinalTime;
    var dateTime1;
    var dateTime2;
    HrisUtil.checkConnection().then((isConnected) => {
      if(isConnected){
        //validate late in or early out
        stFinalTime = etDateAbsent.text.toString() +" "+stInputTime,
        dateTime2 = DateFormat('yyyy-M-d H:m').parse(stFinalTime),
        if(_groupValue == 1){
          dateTime1 = DateFormat('yyyy-M-d H:m').parse(stAbsentIn),
          dateTime2.isAfter(dateTime1) ? reasonValidation(context) : initUIdToken(1, context)
        }else{
          dateTime1 = DateFormat('yyyy-M-d H:m').parse(stAbsentOut),
          dateTime2.isBefore(dateTime1) ? reasonValidation(context) : initUIdToken(1, context)
        }
      }else{hrisUtil.showNoActionDialog(ConstanstVar.noConnectionTitle, ConstanstVar.noConnectionMessage, context)}
    });
  }

  Future<ErrorResponse> _submitAbsent(BuildContext context, PostJsonAbsent postData) async {
    try{
        LoadingUtils.showLoadingDialog(context, _keyLoader);
        _apiServiceUtils.createAbsent(postData).then((value) => {
          print(jsonDecode(value)),
          responseCode = ErrorResponse.fromJson(jsonDecode(value)).code,
            stResponseMessage = ErrorResponse.fromJson(jsonDecode(value)).message,
          Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop(),
          if(responseCode == ConstanstVar.successCode){
              if(stResponseMessage == "Success Absent"){
                hrisUtil.toastMessage("$stResponseMessage"),
                onbackScreen(),
              }else{hrisUtil.snackBarMessageScaffoldKey("$stResponseMessage", scaffoldKey),}
          }else{hrisUtil.snackBarMessageScaffoldKey("$stResponseMessage", scaffoldKey),}
        });
    }catch(error){
      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
      hrisUtil.snackBarMessageScaffoldKey("err load claim " +error.toString(), scaffoldKey);
    }
    return null;
  }

  void onbackScreen(){
    Navigator.pop(context, '');
  }

  void validateConnection(BuildContext context){
    HrisUtil.checkConnection().then((isConnected) => {
      isConnected ? _getAbsentOut() : hrisUtil.snackBarMessage(ConstanstVar.noConnectionMessage, context)
    });
  }

  Future<ResponseAbsentOut> _getAbsentOut() async{
    loadingOption();
    _apiServiceUtils.getMasterAbsentOut(loadingOption).then((value) => {
      print(jsonDecode(value)),
      responseCode = ResponseAbsentOut.fromJson(jsonDecode(value)).code,
      if(responseCode == ConstanstVar.successCode){
          stAbsentOut = ResponseAbsentOut.fromJson(jsonDecode(value)).absentOut,
          stAbsentIn = ResponseAbsentOut.fromJson(jsonDecode(value)).absentIn,
      }else{
        stResponseMessage = ErrorResponse.fromJson(jsonDecode(value)).message,
        hrisUtil.toastMessage("$stResponseMessage")
      }
    });
    return null;
  }

  void reasonValidation(BuildContext context){
    String messageText = "";
    _groupValue == 1 ? messageText = 'Please fill the reason if you late absent in' : messageText = 'Please fill the reason if you want to early absent out';
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(messageText),
            content: TextField(
              onChanged: (value) {
                setState(() => reasonAbsent = value);
              },
              controller: etReasonDialogAbsent,
              decoration: InputDecoration(hintText: "Reason"),
            ),
            actions: <Widget>[
              TextButton(child: Text('OK'),
                onPressed: (){
                  Navigator.of(context, rootNavigator: true).pop();
                  //submitAbsent
                  initUIdToken(1, context);
                },
              ),
              TextButton(child: Text('Cancel'),
                onPressed: (){
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
          );
        });
  }

  void loadingOption(){
    setState(() {
      isLoading = !isLoading;
    });
  }

  //view
  Widget _initDetail(BuildContext context){
    return Form(
      key: _formKey,
      child: new Container(
        padding: const EdgeInsets.all(10.0),
        color: Colors.white,
        child: new SingleChildScrollView(
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
                  enabled: false,
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
                isShowReasonText ? new Column(
                    children: <Widget>[
                      new Padding(padding: EdgeInsets.only(top: 30.0)),
                      new TextFormField(
                        controller: etReasonAbsent,
                        enabled: false,
                        maxLines: 3,
                        decoration: new InputDecoration(
                          labelText: "Reason",
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(15.0),
                            borderSide: new BorderSide(
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        style: new TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                    ]
                ) : Text(""),
                new Padding(padding: EdgeInsets.only(top: 50.0)),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                        isHiddenButton ? new RawMaterialButton(
                          fillColor: Colors.blue,
                          splashColor: Colors.yellow,
                          padding: EdgeInsets.only(left: 50, top:20, right: 50, bottom: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.yellow)
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()){
                              if(_groupValue == -1){
                                hrisUtil.snackBarMessageScaffoldKey("Please choose absent type", scaffoldKey);
                              }else if(etAddressAbsent.text.isEmpty){
                                hrisUtil.snackBarMessageScaffoldKey(ConstanstVar.blankStatement, scaffoldKey);
                              } else{
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Text("Are you sure want to absent ? "),
                                      actions: <Widget>[
                                        TextButton(child: Text('OK'),
                                          onPressed: (){
                                            Navigator.of(context, rootNavigator: true).pop();
                                            //submitAbsent
                                            validateConnectionSubmit(context);
                                          },
                                        ),
                                        TextButton(child: Text('Cancel'),
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
                            style: TextStyle(fontSize: 20.0, color: Colors.white),
                          ),
                        ) : Text(""),
                      isHiddenButton ?
                      new RawMaterialButton(
                        fillColor: Colors.white,
                        splashColor: Colors.white54,
                        padding: EdgeInsets.only(left: 50, top:20, right: 50, bottom: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.grey)
                        ),
                        onPressed: () {
                          // Navigator.pop(context, '');
                          Navigator.of(context).pop('String');
                        },
                        child: Text(
                          "Cancel",
                          style: TextStyle(fontSize: 20.0, color:Colors.black),
                        ),
                      )
                          : Text(""),
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
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Absent'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_location,
              color: Colors.white,
            ),
            onPressed: () {
              if(widget.absentModel == null){_gpsValidaton(context);}
            },
          )
        ],
      ),
      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : _initDetail(context),
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
  // }
}