
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

  Widget _initLogin(BuildContext context){
    return Form(
      child: new Container(
        padding: const EdgeInsets.all(10.0),
        color: Colors.white,

        child: new Container(
          child: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                  new Padding(padding: EdgeInsets.only(top: 0.0)),
                  new TextFormField(
                    controller: etLoginUsername,
                    decoration: new InputDecoration(
                      labelText: "Username",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(15.0),
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
                      labelText: "Password",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(15.0),
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
              ],
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
  Widget build(BuildContext context) {
      return Scaffold(body: _initLogin(context),
    );
  }
}