
import 'package:absent_hris/adapter/BottomMenuAdapter.dart';
import 'package:absent_hris/util/HrisStore.dart';
import 'package:absent_hris/util/MessageUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginActivity extends StatefulWidget {
  @override
  _LoginActivityState createState() => _LoginActivityState();
}

class _LoginActivityState extends State<LoginActivity> {
  TextEditingController etLoginUsername = new TextEditingController();
  TextEditingController etLoginPass = new TextEditingController();
  bool _obscureText = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  HrisStore hrisStore = HrisStore();
  MessageUtil messageUtil = MessageUtil();

  @override
  void initState() {
    super.initState();
    Future<String> authUn = hrisStore.getAuthUsername();
    authUn.then((data) {
      if(data != ""){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BottomMenuNavigationAdapter()),
        );
      }
    },onError: (e) {
      messageUtil.toastMessage(e);
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
                    new FlatButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      disabledColor: Colors.blueGrey,
                      disabledTextColor: Colors.black,
                      padding: EdgeInsets.only(left: 120, top:20, right: 120, bottom: 20),
                      splashColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.yellow)
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()){_submitLogin();}
                      },
                      child: Text(
                        "LOG IN",
                        style: TextStyle(fontSize: 20.0),
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

  void _submitLogin(){
      hrisStore.setAuthUsername(etLoginUsername.text);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BottomMenuNavigationAdapter()),
      );
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(body: _initLogin(context),
    );
  }
}