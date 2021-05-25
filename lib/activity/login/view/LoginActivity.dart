import 'package:absent_hris/activity/login/contract/ContractLogin.dart';
import 'package:absent_hris/activity/login/presenter/PresenterLogin.dart';
import 'package:absent_hris/adapter/BottomMenuAdapter.dart';
import 'package:absent_hris/util/ApiServiceUtils.dart';
import 'package:absent_hris/util/ConstanstVar.dart';
import 'package:absent_hris/util/LoadingUtils.dart';
import 'package:absent_hris/util/HrisUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginActivity extends StatefulWidget {
  @override
  _LoginActivityState createState() => _LoginActivityState();
}

class _LoginActivityState extends State<LoginActivity> implements LoginActivityView {
  TextEditingController etLoginUsername = new TextEditingController();
  TextEditingController etLoginPass = new TextEditingController();
  bool _obscureText = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  HrisUtil _hrisUtil = HrisUtil();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  PresenterLogin _presenterLogin;

  @override
  void initState() {
    super.initState();
    _presenterLogin = PresenterLogin(this);
    _presenterLogin.initLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _initViewLogin(context),
    );
  }

  Widget _initViewLogin(BuildContext context){
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
                          _presenterLogin.validateConn(context,etLoginUsername.text.trim(), etLoginPass.text.trim());
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

  @override
  void goToHome() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BottomMenuNavigationAdapter()),
    );
  }

  @override
  void onAlertDialog(String titleMsg, titleContent, BuildContext context) {
    // implement onAlertDialog
    _hrisUtil.showNoActionDialog(titleMsg,
        titleContent, context);
  }

  @override
  void toastLogin(String message) => _hrisUtil.toastMessage(message);

  @override
  void loadingBar(int typeLoading) {
    // implement loadingBar
    typeLoading == ConstanstVar.showLoadingBar ? LoadingUtils.showLoadingDialog(context, _keyLoader)
        : Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
  }
}