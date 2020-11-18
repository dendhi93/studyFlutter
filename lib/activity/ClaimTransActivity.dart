
import 'dart:convert';
import 'package:absent_hris/model/ErrorResponse.dart';
import 'package:absent_hris/model/ResponseClaimDataModel.dart';
import 'package:absent_hris/model/ResponseDetailMasterClaim.dart';
import 'package:absent_hris/model/ResponseMasterClaim.dart';
import 'package:absent_hris/util/ApiServiceUtils.dart';
import 'package:absent_hris/util/ConstanstVar.dart';
import 'package:absent_hris/util/HrisUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ClaimTransActivity extends StatefulWidget{
  final ResponseClaimDataModel claimModel;
  ClaimTransActivity({Key key, @required this.claimModel}) : super(key: key);

  @override
  _ClaimTransActivityState createState() => _ClaimTransActivityState();
}

class _ClaimTransActivityState extends State<ClaimTransActivity> {
  DateTime currentBackPressTime;
  HrisUtil messageUtil = HrisUtil();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController etDateClaim = new TextEditingController();
  TextEditingController etOtherClaim = new TextEditingController();
  TextEditingController etSelectedClaimType = new TextEditingController();
  DateTime selectedDate = DateTime.now();
  ApiServiceUtils _apiServiceUtils = ApiServiceUtils();
  var isEnableText = false;
  var isHideDetailText = false;
  var isShowDropDown = true;
  HrisUtil _hrisUtil = HrisUtil();
  int responseCode = 0;
  List<ResponseDetailMasterClaim> listDtlMasterClaim = List();
  List<ResponseDetailMasterClaim> arrDtlMasterClaim = [];
  String stResponseMessage,_selectedMasterClaim;
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    if(widget.claimModel != null){
      isEnableText = false;
      isShowDropDown = false;
      etDateClaim.text = widget.claimModel.transDate;
      etSelectedClaimType.text = widget.claimModel.claimDesc;
    }else{isEnableText = true;}
    validateConnection(context);
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      messageUtil.toastMessage("please tap again to exit");
      return Future.value(false);
    }
    return SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  Widget _initClaim(BuildContext context){
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
                          enabled: isEnableText,
                          controller: etDateClaim,
                          onTap: (){
                            FocusScope.of(context).requestFocus(new FocusNode());
                              _selecDatePicker(context);
                          },
                          decoration: new InputDecoration(
                            labelText: "Date Claim",
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
                        isShowDropDown ?
                          DropdownButton(
                            hint: Text("Select Claim Type"),
                            value: _selectedMasterClaim,
                            items: arrDtlMasterClaim.map((value) {
                              return DropdownMenuItem(
                                child: Text(value.claimDesc),
                                value: value.id,
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedMasterClaim = value;
                                if(_selectedMasterClaim == "Lainnya"){
                                    setState(() {
                                      isHideDetailText = true;
                                    });
                                }else{
                                  setState(() {
                                    isHideDetailText = false;
                                  });
                                }
                                _hrisUtil.toastMessage(_selectedMasterClaim);
                              });
                            },
                          ) : new TextFormField(
                          enabled: false,
                          controller: etSelectedClaimType,
                          decoration: new InputDecoration(
                            contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
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
                        new Padding(padding: EdgeInsets.only(top: 10.0)),
                        isHideDetailText ?
                        new TextFormField(
                          enabled: isEnableText,
                          controller: etOtherClaim,
                          decoration: new InputDecoration(
                            labelText: "type Claim",
                            contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                              borderSide: new BorderSide(
                              ),
                            ),
                          ),
                          validator: (val) {
                            if(val.length==0 && _selectedMasterClaim == "Lainnya") {return "Type Claim cannot be empty";
                            }else{return null;}
                          },
                          keyboardType: TextInputType.text,
                          style: new TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ) : Text(''),
                      ],
                  ),
              ),
          ),
        ),
    );
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
        etDateClaim.text = selectedDateFormat;
      });
  }

  void validateConnection(BuildContext context){
    HrisUtil.checkConnection().then((isConnected) => {
      isConnected ? _loadMasterClaim()
          : _hrisUtil.showNoActionDialog(ConstanstVar.noConnectionTitle, ConstanstVar.noConnectionMessage, context)
    });
  }

  Future<ResponseMasterClaim> _loadMasterClaim() async{
    loadingOption();
      _apiServiceUtils.getMasterClaim().then((value) => {
          responseCode = ResponseMasterClaim.fromJson(jsonDecode(value)).code,
        if(responseCode == ConstanstVar.successCode){
           listDtlMasterClaim = ResponseMasterClaim.fromJson(jsonDecode(value)).masterClaim,
           if(listDtlMasterClaim.length > 0){
             arrDtlMasterClaim.addAll(listDtlMasterClaim)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Claim'),
      ),
      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : _initClaim(context),
    );
  }
}