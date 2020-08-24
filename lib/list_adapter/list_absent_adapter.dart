
import 'package:absent_hris/model/ModelAbsensi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListAdapter extends StatefulWidget{
  final ModelAbsensi modelAbsensi;
  ListAdapter({this.modelAbsensi});

  @override
  _ListAdapterState createState() => _ListAdapterState();
}



class _ListAdapterState extends State<ListAdapter> {
  String reasonAbsent = "";

  @override
  void initState() {
    super.initState();
      reasonAbsent = widget.modelAbsensi.reason;
      if(reasonAbsent != "") {
        reasonAbsent = "\nReason " +widget.modelAbsensi.reason;
      }else{return null;}
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child : Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text("Time " +widget.modelAbsensi.timeIn + " - " +widget.modelAbsensi.timeOut),
                subtitle: Text(widget.modelAbsensi.addressAbsent+""+reasonAbsent),
                trailing: Text(widget.modelAbsensi.dateAbsent),
              )
            ],
          ),
        )
    );
  }
}