import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListClaimdapter extends StatefulWidget{

  @override
  _ListClaimdapterState createState() => _ListClaimdapterState();
}

class _ListClaimdapterState extends State<ListClaimdapter> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child : Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: new Image.asset(
                  "assets/ic_ok_24.png" ,
                  fit: BoxFit.cover,
                  width: 24.0,
                ),
                title: Text(""),
                subtitle: Text(""),
                trailing: Text(""),
              )
            ],
          ),
        )
    );
  }


}