import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class HrisUtil {

  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  void snackBarMessage(String message, BuildContext context) {
    final snackBar = SnackBar(content: Text(message),backgroundColor: Colors.blue);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void snackBarMessageScaffoldKey(String message, GlobalKey<ScaffoldState> scaffoldKey) {
    // ignore: deprecated_member_use
    scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 3),
        ));
  }

  static Future<bool> checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  String idrFormating(String inputMoney) {
    if (inputMoney.length > 2) {
      var value = inputMoney;
      value = value.replaceAll(RegExp(r'\D'), '');
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.');
      return value;
    }
    return "";
  }

  int dateDiff(String startDate, String endDate){
    try{
      var splitStartValue = startDate.split("-");
      var splitEndValue = endDate.split("-");
      final dateOne = DateTime(int.parse(splitStartValue[0]), int.parse(splitStartValue[1]), int.parse(splitStartValue[2]));
      final dateTwo = DateTime(int.parse(splitEndValue[0]), int.parse(splitEndValue[1]), int.parse(splitEndValue[2]));
      return dateTwo.difference(dateOne).inDays+1;
    }catch(error){
      print("err load claim " +error.toString());
      return 0;
    }
  }

  int timeDiff(String startTime, String endTime){
    try{
      var splitStartValue = startTime.split("-");
      var splitEndValue = endTime.split("-");
      Duration startDuration = new Duration(hours:int.parse(splitStartValue[3]), minutes:int.parse(splitStartValue[4]), seconds:0);
      Duration endtDuration = new Duration(hours:int.parse(splitEndValue[3]), minutes:int.parse(splitEndValue[4]), seconds:0);
      int durationHours = startDuration.inHours - endtDuration.inHours;
      return durationHours;
    }catch(error){
      print("err load claim " +error.toString());
      return 0;
    }
  }

  String nameOfDay(var inputDate){
    if(inputDate != null){
      return DateFormat('EEEE').format(inputDate).toString();
    }
    return "";
  }

  void showNoActionDialog(String title, String content, BuildContext context) =>
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: new Text(title),
                content: new Text(content),
                actions: <Widget>[
                  new TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: new Text("Close"))
                ]
            );
          }
      );
}