
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:absent_hris/model/ErrorResponse.dart';
import 'package:absent_hris/model/MasterClaim/GetClaim/ResponseClaimDataModel.dart';
import 'package:absent_hris/model/MasterClaim/master/ResponseDetailMasterClaim.dart';
import 'package:absent_hris/model/MasterClaim/master/ResponseMasterClaim.dart';
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
  var isShowDetailText = false;
  var isEnableDropDown = true;
  var isHiddenButton = true;
  HrisUtil _hrisUtil = HrisUtil();
  int responseCode = 0;
  List<ResponseDetailMasterClaim> listDtlMasterClaim = List();
  List<ResponseDetailMasterClaim> arrDtlMasterClaim = [];
  ResponseDetailMasterClaim _selectedResponseDtlMasterClaim;
  String stResponseMessage,_selectedMasterClaim;
  String stringFileClaim = "";
  var isLoading = false;
  File _image;
  final picker = ImagePicker();
  Uint8List _bytesImage;

  @override
  void initState() {
    super.initState();
    if(widget.claimModel != null){
      etDateClaim.text = widget.claimModel.transDate;
      etSelectedClaimType.text = widget.claimModel.claimDesc;
      String moneyIdr = _hrisUtil.idrFormating(widget.claimModel.paidClaim.toString());
      etPaidClaim.text = moneyIdr.trim();
      etDescClaim.text = widget.claimModel.descClaim;
      stringFileClaim = widget.claimModel.fileClaim;
      if(stringFileClaim != null){_bytesImage = base64.decode(widget.claimModel.fileClaim);}
      if(widget.claimModel.statusId == ConstanstVar.approvedClaimStatus){
        isHiddenButton = !isHiddenButton;
        isEnableText = false;
        isEnableDropDown = false;
      }else{
        isEnableText = true;
        validateConnection(context);
      }
      if(widget.claimModel.detailClaim != ""){
        isShowDetailText = true;
        etOtherClaim.text = widget.claimModel.detailClaim;
      }else{isShowDetailText = false;}
    }else{
      isEnableText = true;
      validateConnection(context);
    }
  }

  //controller
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

  _selectDatePicker(BuildContext context) async{
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

  Future getImage() async {
    var pickedFile = await picker.getImage(source: ImageSource.camera);
    //converting into string base64

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        List<int> imageBytes = _image.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        // print(base64Image);
        _bytesImage = base64.decode(base64Image);
      } else {
        print('No image selected.');
      }
    });
  }

  //view
  Widget _initClaim(BuildContext context){
    return Form(
      key: _formKey,
      child: new SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
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
                    _selectDatePicker(context);
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
                new Column(
                  children: <Widget>[
                    new Padding(padding: EdgeInsets.only(top: 3.0)),
                    DropdownButton(
                      hint: Text("Select Claim Type"),
                      value: _selectedResponseDtlMasterClaim,
                      items: arrDtlMasterClaim.map((value) {
                        return DropdownMenuItem(
                            child: Text(value.claimDesc),
                            value: value.id+'-'+value.paidClaim.toString()+'-'+value.claimDesc
                        );
                      }).toList(),
                      onChanged: (value) {
                        if(isEnableDropDown){
                          setState(() {
                            var splitValue = value.split("-");
                            _selectedMasterClaim = splitValue[0];
                            etAvailableClaimTotal.text = _hrisUtil.idrFormating(splitValue[1]);
                            etSelectedClaimType.text = splitValue[2];
                            _selectedMasterClaim == "7" ? isShowDetailText = true : isShowDetailText = false;
                          });
                        }
                      },
                    )
                  ],
                ),
                new Column(
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
                isShowDetailText ?
                new Column(
                  children: <Widget>[
                    new Padding(padding: EdgeInsets.all(5.0)),
                    new TextFormField(
                      enabled: isEnableText,
                      controller: etOtherClaim,
                      decoration: new InputDecoration(
                        labelText: "Type claim",
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
                      maxLength:100,
                      keyboardType: TextInputType.text,
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                    )
                  ],
                ): Container(
                    color: Colors.white // This is optional
                ),
                isEnableDropDown ?
                new Column(
                  children: <Widget>[
                    new Padding(padding: EdgeInsets.only(top: 5.0)),
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
                      maxLength:100,
                      keyboardType: TextInputType.text,
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                    )
                  ],
                ): Container(
                    color: Colors.white
                ),
                new Padding(padding: EdgeInsets.only(top: 10.0)),
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
                      new Column(
                          children: <Widget>[
                            _bytesImage == null
                                ? new Text('No Image Selected',style: TextStyle(fontSize: 17.0))
                                : new Image.memory(_bytesImage,
                              width: 450,
                              height: 150,
                            ),
                          ]
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

                new Padding(padding: EdgeInsets.only(top: 25.0)),
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
        title: Text('Claim'),
      ),
      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : _initClaim(context),
    );
  }
}
