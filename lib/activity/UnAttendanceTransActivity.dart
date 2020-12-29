
import 'dart:convert';

import 'package:absent_hris/model/ErrorResponse.dart';
import 'package:absent_hris/model/Master_UnAttendance/GetUnAttendance/ResponseDtlUnAttendance.dart';
import 'package:absent_hris/model/Master_UnAttendance/master/ResponseDtlMasterUnAttendance.dart';
import 'package:absent_hris/model/Master_UnAttendance/master/ResponseHeadMasterUnAttendance.dart';
import 'package:absent_hris/util/ApiServiceUtils.dart';
import 'package:absent_hris/util/ConstanstVar.dart';
import 'package:absent_hris/util/HrisUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UnAttendanceTransActivity extends StatefulWidget {
  final ResponseDtlUnAttendance unAttendanceModel;
  UnAttendanceTransActivity({Key key, @required this.unAttendanceModel}) : super(key: key);

  @override
  _UnAttendanceTransActivityState createState() => _UnAttendanceTransActivityState();
}

class _UnAttendanceTransActivityState extends State<UnAttendanceTransActivity> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController etStartDate = new TextEditingController();
  TextEditingController etEndDate = new TextEditingController();
  TextEditingController etQtyDate = new TextEditingController();
  TextEditingController etUnAttendanceType = new TextEditingController();
  TextEditingController etNoteUnAttendance = new TextEditingController();
  List<ResponseDtlMasterUnAttendance> arrDtlMasterUnAttendance = [];
  ResponseDtlMasterUnAttendance _selectedDtlMasterUnAttendance;
  List<ResponseDtlMasterUnAttendance> listDtlMasterUnAttendance = List();
  HrisUtil _hrisUtil = HrisUtil();
  DateTime selectedDate = DateTime.now();
  ApiServiceUtils _apiServiceUtils = ApiServiceUtils();
  var isEnableText = true;
  var isEnableDropdown = true;
  var isShowButton = true;
  var isHideNoteUnAttendance = false;
  int statusTrans = 0;
  int responseCode = 0;
  var isLoading = false;
  String stResponseMessage,_selectedUnAttendanceType;

  @override
  void initState() {
    super.initState();
    if(widget.unAttendanceModel != null){
      statusTrans = widget.unAttendanceModel.statusId;
      if(statusTrans == ConstanstVar.approvedClaimStatus){
        isEnableText = !isEnableText;
        isEnableDropdown = !isEnableDropdown;
        isShowButton = !isShowButton;
      }else{validateConnection(context);}

      etStartDate.text = widget.unAttendanceModel.startDate;
      etEndDate.text = widget.unAttendanceModel.endDate;
      etQtyDate.text = widget.unAttendanceModel.qtyDate.toString();
      etUnAttendanceType.text = widget.unAttendanceModel.unattendanceDesc;
    }else{validateConnection(context);}
  }

  //controller
  void validateConnection(BuildContext context){
    HrisUtil.checkConnection().then((isConnected) => {
      isConnected ? _loadMasterUnAttendance()
          : _hrisUtil.showNoActionDialog(ConstanstVar.noConnectionTitle, ConstanstVar.noConnectionMessage, context)
    });
  }

  Future<ResponseHeadMasterUnAttendance> _loadMasterUnAttendance() async{
    loadingOption();
    _apiServiceUtils.getMasterUnAttendance().then((value) => {
      responseCode = ResponseHeadMasterUnAttendance.fromJson(jsonDecode(value)).code,
      if(responseCode == ConstanstVar.successCode){
        listDtlMasterUnAttendance = ResponseHeadMasterUnAttendance.fromJson(jsonDecode(value)).masterUnAttendance,
        if(listDtlMasterUnAttendance.length > 0){
          arrDtlMasterUnAttendance.addAll(listDtlMasterUnAttendance),
        },
      }else{
        stResponseMessage = ErrorResponse.fromJson(jsonDecode(value)).message,
        _hrisUtil.toastMessage("$stResponseMessage")
      }
    });
    new Future.delayed(const Duration(seconds: 1), () {
      loadingOption();
    });
    return null;
  }

  void loadingOption(){
    setState(() {
      isLoading = !isLoading;
    });
  }

  _selecDatePicker(BuildContext context, int typeDate) async{
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
        typeDate == ConstanstVar.selectStartDate
            ? etStartDate.text = selectedDateFormat : etEndDate.text = selectedDateFormat;
      });
  }

  //view
  Widget _initUnAttendance(BuildContext buildContext){
    return Form(
      key: _formKey,
        child: new SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
            child: new Center(
                child: new Column(
                    children: <Widget>[
                      new Padding(padding: EdgeInsets.only(top: 10.0)),
                      new TextFormField(
                        enabled: isEnableText,
                        controller: etStartDate,
                        onTap: (){
                          FocusScope.of(context).requestFocus(new FocusNode());
                            _selecDatePicker(context, ConstanstVar.selectStartDate);
                        },
                        decoration: new InputDecoration(
                          labelText: "Start Date",
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
                      new Padding(padding: EdgeInsets.only(top: 15.0)),
                      new TextFormField(
                        enabled: isEnableText,
                        controller: etEndDate,
                        onTap: (){
                          FocusScope.of(context).requestFocus(new FocusNode());
                            _selecDatePicker(context, ConstanstVar.selectEndDate);
                        },
                        decoration: new InputDecoration(
                          labelText: "End Date",
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
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Container(
                              width: 120,
                              child: new TextFormField(
                                enabled: false,
                                controller: etQtyDate,
                                decoration: new InputDecoration(
                                  labelText: "Qty Date",
                                  contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                                  fillColor: Colors.white,
                                  border: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(15.0),
                                    borderSide: new BorderSide(
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                style: new TextStyle(
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ),
                          ]
                      ),
                      new Column(
                        children: <Widget>[
                          new Padding(padding: EdgeInsets.only(top: 3.0)),
                          DropdownButton(
                            hint: Text("Select Claim Type"),
                            value: _selectedDtlMasterUnAttendance,
                            items: arrDtlMasterUnAttendance.map((value) {
                              return DropdownMenuItem(
                                  child: Text(value.unAttendanceDesc),
                                  value: value.id+'-'+value.unAttendanceDesc
                              );
                            }).toList(),
                            onChanged: (value) {
                              if(isEnableDropdown){
                                setState(() {
                                  var splitValue = value.split("-");
                                  _selectedUnAttendanceType = splitValue[0].toString();
                                  etUnAttendanceType.text = splitValue[1];
                                   _selectedUnAttendanceType == "8" ? isHideNoteUnAttendance = true : isHideNoteUnAttendance = false;
                                });
                              }
                            },
                          ),
                          new Padding(padding: EdgeInsets.only(top: 10.0)),
                          new TextFormField(
                            enabled: false,
                            controller: etUnAttendanceType,
                            decoration: new InputDecoration(
                              labelText: "UnAttendance Type",
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
                            keyboardType: TextInputType.text,
                            maxLength: 25,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                          isHideNoteUnAttendance ?
                          new Column(
                            children: <Widget>[
                              new TextFormField(
                                enabled: isEnableText,
                                controller: etNoteUnAttendance,
                                decoration: new InputDecoration(
                                  labelText: "Note UnAttendance",
                                  contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                                  fillColor: Colors.white,
                                  border: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(15.0),
                                    borderSide: new BorderSide(
                                    ),
                                  ),
                                ),
                                validator: (val) {
                                  if(val.length==0 && _selectedUnAttendanceType == "8") {return "Type Claim cannot be empty";
                                  }else{return null;}
                                },
                                maxLength:100,
                                keyboardType: TextInputType.text,
                                style: new TextStyle(
                                  fontFamily: "Poppins",
                                ),
                              )
                            ],
                          ): Container(color: Colors.white // This is optional
                          ),
                        ],
                      ),
                      new Padding(padding: EdgeInsets.only(top: 25.0)),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          isShowButton ? new FlatButton(
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

                          isShowButton ? new FlatButton(
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
                    ]
                ),
            ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UnAttendance Plan'),
      ),
      body: _initUnAttendance(context)
    );
  }
}
