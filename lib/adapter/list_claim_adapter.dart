
import 'package:absent_hris/model/MasterClaim/GetClaim/ResponseClaimDataModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListClaimAdapter extends StatefulWidget{
  final ResponseClaimDataModel responseClaimDataModel;
  ListClaimAdapter({this.responseClaimDataModel});

  @override
  ListClaimAdapterState createState() => ListClaimAdapterState();
}

class ListClaimAdapterState extends State<ListClaimAdapter> {
  int statusClaim = 0;
  String imageClaim = "";

  @override
  void initState() {
    super.initState();
    statusClaim = widget.responseClaimDataModel.statusId;
    if(statusClaim != null){
        if(statusClaim == 1){
            imageClaim = "ic_sand.png";
        }else if(statusClaim == 2){
            imageClaim = "ic_ok_24.png";
        }else{
            imageClaim = "ic_cross.png";
        }
    }else{
      statusClaim = null;
      imageClaim = null;
    }
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
                  "assets/images/"+imageClaim ,
                  fit: BoxFit.cover,
                  width: 24.0,
                ),
                title: Text(widget.responseClaimDataModel.claimDesc.trim()),
                trailing: Text(widget.responseClaimDataModel.nameRequester.trim()),
                subtitle: Text(widget.responseClaimDataModel.transDate),
              )
            ],
          ),
        )
    );
  }
}