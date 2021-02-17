
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:absent_hris/model/ErrorResponse.dart';
import 'package:absent_hris/model/MasterClaim/GetClaim/ResponseClaimDataModel.dart';
import 'package:absent_hris/model/MasterClaim/PostClaim/PostJsonClaimTR.dart';
import 'package:absent_hris/model/MasterClaim/master/ResponseDetailMasterClaim.dart';
import 'package:absent_hris/model/MasterClaim/master/ResponseMasterClaim.dart';
import 'package:absent_hris/util/ApiServiceUtils.dart';
import 'package:absent_hris/util/ConstanstVar.dart';
import 'package:absent_hris/util/HrisStore.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
  var isHiddenButtonCapture = true;
  HrisUtil _hrisUtil = HrisUtil();
  HrisStore _hrisStore = HrisStore();
  int responseCode = 0;
  int intTransClaimId = 0;
  int intStatusId = 0;
  List<ResponseDetailMasterClaim> listDtlMasterClaim = [];
  List<ResponseDetailMasterClaim> arrDtlMasterClaim = [];
  ResponseDetailMasterClaim _selectedResponseDtlMasterClaim;
  String stResponseMessage,_selectedMasterClaim;
  String stringFileClaim = "";
  String stToken,stUid,_userType;
  String stLowerId = "";
  var isLoading = false;
  File _image;
  final picker = ImagePicker();
  Uint8List _bytesImage;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  void initState() {
    super.initState();
    Future<String> authUType = _hrisStore.getAuthUserLevelType();
    authUType.then((data) {
      _userType = data.trim();

      if(widget.claimModel != null){
        etDateClaim.text = widget.claimModel.transDate;
        etSelectedClaimType.text = widget.claimModel.claimDesc;
        String moneyIdr = _hrisUtil.idrFormating(widget.claimModel.paidClaim.toString());
        etPaidClaim.text = moneyIdr.trim();
        etDescClaim.text = widget.claimModel.descClaim;
        stringFileClaim = widget.claimModel.fileClaim;
        intTransClaimId = widget.claimModel.idTrans;
        stLowerId = widget.claimModel.lowerUserId;
        if(stringFileClaim != null){_bytesImage = base64.decode(widget.claimModel.fileClaim);}
        intStatusId = widget.claimModel.statusId;
        if(intStatusId == ConstanstVar.approvedClaimStatus){
          isHiddenButton = !isHiddenButton;
          isEnableText = false;
          isEnableDropDown = false;
        }else{
          isEnableText = true;
          validateConnection(context);
          if(_userType == "approval"){isHiddenButtonCapture = !isHiddenButtonCapture;}
        }
        if(widget.claimModel.detailClaim != ""){
          isShowDetailText = true;
          etOtherClaim.text = widget.claimModel.detailClaim;
        }else{isShowDetailText = false;}
      }else{
        isEnableText = true;
        validateConnection(context);
      }

    });
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
        print(jsonDecode(value)),
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

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        //converting into string base64
        List<int> imageBytes = _image.readAsBytesSync();
        stringFileClaim = base64Encode(imageBytes);
        // print(base64Image);
        _bytesImage = base64.decode(stringFileClaim);
      } else {print('No image selected.');}
    });
  }

  void validateConnectionTransaction(BuildContext context){
    HrisUtil.checkConnection().then((isConnected) => {
      isConnected ? _loadMasterClaim()
          : _hrisUtil.showNoActionDialog(ConstanstVar.noConnectionTitle, ConstanstVar.noConnectionMessage, context)
    });
  }

  void initUIdToken(int intType, BuildContext context){
    if(intType == 1){
      Future<String> authUid = _hrisStore.getAuthUserId();
      authUid.then((data) {
        stUid = data.trim();
        initUIdToken(2, context);
      },onError: (e) {_hrisUtil.toastMessage(e);});
    }else{
      Future<String> authUToken = _hrisStore.getAuthToken();
      authUToken.then((data) {
        stToken = data.trim();
        stUid = stUid+"-"+stToken;
        etOtherClaim.text.isEmpty ? etOtherClaim.text = "-" : etOtherClaim.text =  etOtherClaim.text.trim();
        if(intTransClaimId == 0){intStatusId = 1;}
        PostJsonClaimTR _postClaimTR = PostJsonClaimTR(userId: stUid,
            dateTrans: etDateClaim.text.trim(), claimId: _selectedMasterClaim,
            detailClaim: etOtherClaim.text.trim(), paidClaim: int.parse(etPaidClaim.text.trim()),
            descClaim: etDescClaim.text.trim(), lowerUserId: stLowerId.trim(),
            transId: intTransClaimId.toString(), fileClaim: stringFileClaim,
            statusId: intStatusId.toString(),reasonReject: "");

        print(PostJsonClaimTR().postClaimToJson(_postClaimTR));
        // _submitAbsent(context, _postJsonAbsent);
      },onError: (e) {_hrisUtil.toastMessage(e);});
    }
  }

  Future<ErrorResponse> _submitClaim(BuildContext context, PostJsonClaimTR postData) async {
    try{

    }catch(error){
      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
      _hrisUtil.snackBarMessageScaffoldKey("err load claim " +error.toString(), _scaffoldKey);
    }
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
                      isHiddenButtonCapture ? new RawMaterialButton(
                        fillColor: Colors.blue,
                        splashColor: Colors.yellow,

                        padding: EdgeInsets.only(left: 50, top:20, right: 50, bottom: 20),
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
                          style: TextStyle(fontSize: 20.0, color:Colors.white),
                        ),
                      ): Text(""),
                    ]
                ),

                new Padding(padding: EdgeInsets.only(top: 25.0)),
                _userType == 'requester' ? new Row(
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
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text("Are you sure want to absent ?"),
                                    actions: <Widget>[
                                      TextButton(child: Text('OK'),
                                        onPressed: (){
                                          Navigator.of(context, rootNavigator: true).pop();
                                          //submitclaim
                                          validateConnectionTransaction(context);
                                        },
                                      ),
                                      TextButton(child: Text('Cancel'),
                                        onPressed: (){
                                          Navigator.of(context, rootNavigator: true).pop();
                                          //back to previous screen
                                          // Navigator.pop(context, '');
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
                            style: TextStyle(fontSize: 20.0,color:Colors.white),
                          ),
                        ) : Text(""),

                        isHiddenButton ? new RawMaterialButton(
                          fillColor: Colors.white,
                          splashColor: Colors.white,
                          padding: EdgeInsets.only(left: 50, top:20, right: 50, bottom: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.grey)
                          ),
                          onPressed: () {
                            Navigator.pop(context, '');
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(fontSize: 20.0, color: Colors.black),
                          ),
                        ) : Text(""),
                      ],
                ) : new Row(
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
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text("Are you sure want to absent ?"),
                                    actions: <Widget>[
                                      TextButton(child: Text('OK'),
                                        onPressed: (){
                                          Navigator.of(context, rootNavigator: true).pop();
                                          //submitclaim
                                          // validateConnectionTransaction(context);
                                        },
                                      ),
                                      TextButton(child: Text('Cancel'),
                                        onPressed: (){
                                          Navigator.of(context, rootNavigator: true).pop();
                                          //back to previous screen
                                          // Navigator.pop(context, '');
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Text(
                            "Approve",
                            style: TextStyle(fontSize: 20.0,color:Colors.white),
                          ),
                        ) : Text(""),

                        isHiddenButton ? new RawMaterialButton(
                          fillColor: Colors.white,
                          splashColor: Colors.white54,
                          padding: EdgeInsets.only(left: 50, top:20, right: 50, bottom: 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.grey)
                          ),
                          onPressed: () {
                            _hrisUtil.toastMessage("reject cuy");
                          },
                          child: Text(
                            "Reject",
                            style: TextStyle(fontSize: 20.0, color: Colors.black),
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
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Claim'),
      ),
      body: isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : _initClaim(context),
    );
  }
}
