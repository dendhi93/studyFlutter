
import 'dart:convert';

import 'package:absent_hris/activity/login/contract/ContractLogin.dart';
import 'package:absent_hris/activity/login/presenter/PresenterLogin.dart';
import 'package:absent_hris/adapter/BottomMenuAdapter.dart';
import 'package:absent_hris/model/ErrorResponse.dart';
import 'package:absent_hris/model/Login/ResponseLoginModel.dart';
import 'package:absent_hris/util/ApiServiceUtils.dart';
import 'package:absent_hris/util/ConstanstVar.dart';
import 'package:absent_hris/util/HrisStore.dart';
import 'package:absent_hris/util/LoadingUtils.dart';
import 'package:absent_hris/util/HrisUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginActivity extends StatefulWidget {
  @override
  _LoginActivityState createState() => _LoginActivityState();
}

class _LoginActivityState extends State<LoginActivity> implements View {
  TextEditingController etLoginUsername = new TextEditingController();
  TextEditingController etLoginPass = new TextEditingController();
  bool _obscureText = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  HrisStore _hrisStore = HrisStore();
  HrisUtil _hrisUtil = HrisUtil();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  ApiServiceUtils _apiServiceUtils = ApiServiceUtils();
  String stToken;
  String stName;
  String uLevelId = "";
  String userType = "";
  String stResponseMessage;
  int responseCode = 0;
  String stUId;
  Presenter presenter;

  @override
  void initState() {
    super.initState();
    initUsername();
  }

  void initUsername(){
    Future<String> authUn = _hrisStore.getAuthUsername();
    authUn.then((data) {
      if(data != ""){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BottomMenuNavigationAdapter()),
        );
      }
    },onError: (e) {
      _hrisUtil.toastMessage(e);
    });
  }

  Widget _initLogin(BuildContext context){
    return Form(
      key: _formKey,
      child: new Container(
        padding: const EdgeInsets.all(10.0),
        color: Colors.white,
        child: new Container(
          child: new Center(
            child: new SingleChildScrollView(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text("Hris Mobile",
                        style: TextStyle(fontSize: 27)
                    ),
                    new Padding(padding: EdgeInsets.only(top: 25.0)),
                    new Image.asset('assets/images/ic_logo.png', width: 190, height: 120,),
                    new Padding(padding: EdgeInsets.only(top: 30.0)),
                    new TextFormField(
                      controller: etLoginUsername,
                      decoration: new InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                        labelText: "Username",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          borderSide: new BorderSide(
                          ),
                        ),
                      ),
                      validator: (val) {
                        if(val.length==0) {return "Username cannot be empty";
                        }else{return null;}
                      },
                      keyboardType: TextInputType.text,
                      maxLength: 15,
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),

                    new Padding(padding: EdgeInsets.only(top: 10.0)),
                    new TextFormField(
                      controller: etLoginPass,
                      decoration: new InputDecoration(
                        contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                        labelText: "Password",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          borderSide: new BorderSide(
                          ),
                        ),
                        suffixIcon: IconButton(onPressed: () { _toggle();},
                          icon: Icon(Icons.remove_red_eye),
                        ),
                      ),
                      validator: (val) {
                        if(val.length==0) {return "password cannot be empty";
                        }else{return null;}
                      },
                      obscureText: _obscureText,
                      maxLength: 15,
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                    new Padding(padding: EdgeInsets.only(top: 50.0)),
                    new RawMaterialButton(
                      fillColor: Colors.blue,
                      splashColor: Colors.yellow,
                      padding: EdgeInsets.only(left: 120, top:20, right: 120, bottom: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.yellow)
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()){
                          _validateConnection(context);
                        }
                      },
                      child: Text(
                        "LOG IN",
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ),
                  ],
                ),
            ),
          ),
        ),
      ),
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<ResponseLoginModel> _submitLogin(BuildContext context) async {
    try{
      LoadingUtils.showLoadingDialog(context, _keyLoader);
        _apiServiceUtils.getLogin(etLoginUsername.text.trim(),
            etLoginPass.text.trim()).then((value) => {
        responseCode = ResponseLoginModel.fromJson(jsonDecode(value)).code,
        Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop(),
          if(responseCode == ConstanstVar.successCode){
            uLevelId =  ResponseLoginModel.fromJson(jsonDecode(value)).modelDataLogin.levelId.toString(),
            userType =  ResponseLoginModel.fromJson(jsonDecode(value)).modelDataLogin.userType.toString(),
            stToken = ResponseLoginModel.fromJson(jsonDecode(value)).modelDataLogin.token,
            stName = ResponseLoginModel.fromJson(jsonDecode(value)).modelDataLogin.nameUser,
            stUId = ResponseLoginModel.fromJson(jsonDecode(value)).modelDataLogin.userId.toString(),
            _hrisStore.setAuthUsername(stName, stToken,stUId, uLevelId,userType),
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BottomMenuNavigationAdapter()),
              )
          }else{
            stResponseMessage = ErrorResponse.fromJson(jsonDecode(value)).message,
            _hrisUtil.toastMessage("$stResponseMessage")
          },
        });
    }catch(error){
      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
      _hrisUtil.toastMessage("err Login " +error.toString());
    }
    return null;
  }

  void _validateConnection(BuildContext context) {
    HrisUtil.checkConnection().then((isConnected) => {
        if(isConnected){
          _submitLogin(context),
        }else{
            _hrisUtil.showNoActionDialog(ConstanstVar.noConnectionTitle,
                ConstanstVar.noConnectionMessage, context),
        }
    });
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(body: _initLogin(context),
    );
  }

  @override
  gotoHomePage() {
    // TODO: implement gotoHomePage
    throw UnimplementedError();
  }

  @override
  refresh() {
    // TODO: implement refresh
    throw UnimplementedError();
  }

  @override
  setPresenter(t) {
    // TODO: implement setPresenter
    presenter = t;
    throw UnimplementedError();
  }

  @override
  showLoginError(msg) {
    // TODO: implement showLoginError
    throw UnimplementedError();
  }

  @override
  showLoginSuccess(msg) {
    // TODO: implement showLoginSuccess
    throw UnimplementedError();
  }
}