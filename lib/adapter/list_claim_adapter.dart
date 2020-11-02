import 'package:absent_hris/model/ResponseClaimDataModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListClaimdapter extends StatefulWidget{
  final ResponseClaimDataModel responseClaimDataModel;
  ListClaimdapter({this.responseClaimDataModel});

  @override
  _ListClaimdapterState createState() => _ListClaimdapterState();
}

class _ListClaimdapterState extends State<ListClaimdapter> {
  int statusClaim = 0;
  String imageClaim = "";
  @override
  void initState() {
    statusClaim = widget.responseClaimDataModel.statusId;
    super.initState();
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
                  "assets/"+imageClaim ,
                  fit: BoxFit.cover,
                  width: 24.0,
                ),
                title: Text(widget.responseClaimDataModel.claimDesc.trim()),
                subtitle: Text(widget.responseClaimDataModel.transDate),
              )
            ],
          ),
        )
    );
  }


}