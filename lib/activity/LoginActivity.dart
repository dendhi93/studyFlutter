
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginActivity extends StatefulWidget {
  @override
  _LoginActivityState createState() => _LoginActivityState();
}

class _LoginActivityState extends State<LoginActivity> {

  // Widget _initLogin(BuildContext context){
  //   return Form(
  //       child: new Container(
  //         padding: const EdgeInsets.all(10.0),
  //         color: Colors.white,
  //         child: new Container(
  //             child: new Center(
  //                 child: new Column(
  //                     children: <Widget>[
  //                       new Padding(padding: EdgeInsets.only(top: 10.0)),
  //                       new TextFormField(
  //                         decoration: new InputDecoration(
  //                           labelText: "Username",
  //                           fillColor: Colors.white,
  //                           border: new OutlineInputBorder(
  //                             borderRadius: new BorderRadius.circular(15.0),
  //                             borderSide: new BorderSide(
  //                             ),
  //                           ),
  //                         ),
  //                         validator: (val) {
  //                           if(val.length==0) {return "Date cannot be empty";
  //                           }else{return null;}
  //                         },
  //                         keyboardType: TextInputType.datetime,
  //                         style: new TextStyle(
  //                           fontFamily: "Poppins",
  //                         ),
  //                       ),
  //                     ],
  //                 ),
  //             ),
  //         ),
  //       ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
        child: new Form(
            child: new Container(
              padding: const EdgeInsets.all(10.0),
              color: Colors.white,
              child: new Container(
                  child: new Center(
                      child: new Column(
                          children: <Widget>[
                            new Padding(padding: EdgeInsets.only(top: 10.0)),

                          ],
                      ),
                  ),
              ),
            ),
        )
    );
  }
}