
import 'dart:convert';
import 'dart:io';
import 'package:absent_hris/model/ErrorResponse.dart';
import 'package:absent_hris/model/ResponseClaimDataModel.dart';
import 'package:absent_hris/model/ResponseDetailMasterClaim.dart';
import 'package:absent_hris/model/ResponseMasterClaim.dart';
import 'package:absent_hris/util/ApiServiceUtils.dart';
import 'package:absent_hris/util/ConstanstVar.dart';
import 'package:absent_hris/util/HrisUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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
  TextEditingController etAvailableClaimTotal = new TextEditingController();
  TextEditingController etPaidClaim = new TextEditingController();
  TextEditingController etDescClaim = new TextEditingController();
  DateTime selectedDate = DateTime.now();
  ApiServiceUtils _apiServiceUtils = ApiServiceUtils();
  var isEnableText = false;
  var isHideDetailText = false;
  var isShowDropDown = true;
  var isHiddenButton = true;
  HrisUtil _hrisUtil = HrisUtil();
  int responseCode = 0;
  List<ResponseDetailMasterClaim> listDtlMasterClaim = List();
  List<ResponseDetailMasterClaim> arrDtlMasterClaim = [];
  ResponseDetailMasterClaim _selectedResponseDtlMasterClaim;
  String stResponseMessage,_selectedMasterClaim,_selectedPaidClaim;
  var isLoading = false;
  File _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if(widget.claimModel != null){
      isEnableText = false;
      isShowDropDown = false;
      etDateClaim.text = widget.claimModel.transDate;
      etSelectedClaimType.text = widget.claimModel.claimDesc;
      String moneyIdr = _hrisUtil.idrFormating(widget.claimModel.paidClaim.toString());
      etPaidClaim.text = moneyIdr.trim();
      etDescClaim.text = widget.claimModel.descClaim;
      isHiddenButton = !isHiddenButton;
    }else{
      isEnableText = true;
      validateConnection(context);
    }
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
                        isShowDropDown ?
                        new Column(
                          children: <Widget>[
                            new Padding(padding: EdgeInsets.only(top: 3.0)),
                            DropdownButton(
                              hint: Text("Select Claim Type"),
                              value: _selectedResponseDtlMasterClaim,
                              items: arrDtlMasterClaim.map((value) {
                                return DropdownMenuItem(
                                  child: Text(value.claimDesc),
                                  value: value.id+'-'+value.paidClaim.toString()
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  var splitValue = value.split("-");
                                  _selectedMasterClaim = splitValue[0];
                                  _selectedPaidClaim = splitValue[1];
                                  if(_selectedMasterClaim == "7"){
                                    setState(() {
                                      isHideDetailText = true;
                                    });
                                  }else{
                                    setState(() {
                                      isHideDetailText = false;
                                    });
                                  }
                                  etAvailableClaimTotal.text = _selectedPaidClaim.trim();
                                  // _hrisUtil.toastMessage(_selectedMasterClaim);
                                });
                              },
                            )
                          ],
                        ): new Column(
                              children: <Widget>[
                                new Padding(padding: EdgeInsets.only(top: 10.0)),
                                new TextFormField(
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
                              ],
                        ),
                        isHideDetailText ?
                        new Column(
                          children: <Widget>[
                            new Padding(padding: EdgeInsets.only(top: 10.0)),
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
                            )
                          ],
                        ): Container(
                            color: Colors.white // This is optional
                        ),
                        isShowDropDown ?
                        new Column(
                          children: <Widget>[
                            new Padding(padding: EdgeInsets.only(top: 1.0)),
                            new TextFormField(
                              enabled: false,
                              controller: etAvailableClaimTotal,
                              decoration: new InputDecoration(
                                labelText: "Available Claimed",
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
                            )
                          ],
                        ): Container(
                            color: Colors.white
                        ),
                        new Padding(padding: EdgeInsets.only(top: 20.0)),
                        new TextFormField(
                          enabled: isEnableText,
                          controller: etPaidClaim,
                          decoration: new InputDecoration(
                            labelText: "Paid Claim",
                            contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                              borderSide: new BorderSide(
                              ),
                            ),
                          ),
                          validator: (val) {
                            if(val.length==0) {return "Paid claim cannot be empty";
                            }else{return null;}
                          },
                          maxLength: 8,
                          keyboardType: TextInputType.number,
                          style: new TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                        new TextFormField(
                          enabled: isEnableText,
                          controller: etDescClaim,
                          decoration: new InputDecoration(
                            labelText: "Desc Claim",
                            contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                              borderSide: new BorderSide(
                              ),
                            ),
                          ),
                          validator: (val) {
                            if(val.length==0) {return "desc claim cannot be empty";
                            }else{return null;}
                          },
                          maxLength: 100,
                          keyboardType: TextInputType.text,
                          style: new TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                                 _image == null
                                      ? new Text('No Image Selected',style: TextStyle(fontSize: 17.0))
                                : new Image.file(_image,
                                    width: 350,
                                    height: 150,
                                 ),
                                new Padding(padding: EdgeInsets.only(top: 10.0)),
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
                                    // _hrisUtil.toastMessage("Coba");
                                    // displayCamera();
                                    getImage();
                                  },
                                  child: Text(
                                    "Capture Camera",
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                ): Text(""),
                          ]
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
             arrDtlMasterClaim.addAll(listDtlMasterClaim),
           },
          // _initializeCamera(),
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

  void _clearText() {
    etDateClaim.text = "";
    etOtherClaim.text = "";
    etSelectedClaimType.text = "";
    etAvailableClaimTotal.text = "";
    etPaidClaim.text = "";
    etDescClaim.text = "";
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
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