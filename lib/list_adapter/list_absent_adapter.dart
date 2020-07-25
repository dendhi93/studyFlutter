
import 'package:absent_hris/model/ModelAbsensi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListAdapter extends StatelessWidget{
  final ModelAbsensi modelAbsensi;
  ListAdapter({this.modelAbsensi});

  @override
  Widget build(BuildContext context) {
    return Card(
      child : Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("Time " +modelAbsensi.timeIn + " - " +modelAbsensi.timeOut),
              subtitle: Text("Reason " +modelAbsensi.reason),
              trailing: Text(modelAbsensi.dateAbsent),
            )
          ],
        ),
      )
    );
  }
}