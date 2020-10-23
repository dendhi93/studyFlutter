
import 'dart:convert';

import 'package:absent_hris/activity/DetailAbsentActivity.dart';
import 'package:absent_hris/activity/LoginActivity.dart';
import 'package:absent_hris/adapter/list_absent_adapter.dart';
import 'package:absent_hris/model/ErrorResponse.dart';
import 'package:absent_hris/model/ModelAbsensi.dart';
import 'package:absent_hris/model/ResponseDataAbsent.dart';
import 'package:absent_hris/model/ResponseDtlAbsent.dart';
import 'package:absent_hris/util/ApiServiceUtils.dart';
import 'package:absent_hris/util/ConstanstVar.dart';
import 'package:absent_hris/util/HrisStore.dart';
import 'package:absent_hris/util/LoadingUtils.dart';
import 'package:absent_hris/util/MessageUtil.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

// ignore: must_be_immutable
class HomeActivity extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _HomeActivityState createState() => _HomeActivityState();
}


class _HomeActivityState extends State<HomeActivity> {
    List<ModelAbsensi> listAbsents = [
      ModelAbsensi(dateAbsent: '2020-09-20', transTime: '08:30', absentType: "Absent In", reason: '', addressAbsent :'Multivision Tower'),
      ModelAbsensi(dateAbsent: '2020-09-20', transTime: '17:40', absentType: "Absent Out", reason: '',addressAbsent :'Multivision Tower'),
      ModelAbsensi(dateAbsent: '2020-09-21', transTime: '08:30', absentType: "Absent In", reason: 'Late',addressAbsent :'Plaza Kuningan'),
      ModelAbsensi(dateAbsent: '2020-09-21', transTime: '17:41', absentType: "Absent Out", reason: 'Meetings',addressAbsent :'Multivision Tower'),
      ModelAbsensi(dateAbsent: '2020-09-22', transTime: '08:30', absentType: "Absent In", reason: 'Late',addressAbsent :'Plaza Kuningan'),
      ModelAbsensi(dateAbsent: '2020-09-22', transTime: '17:41', absentType: "Absent Out", reason: '',addressAbsent :'Multivision Tower'),
    ];
    MessageUtil _messageUtil = MessageUtil();
    HrisStore _hrisStore = HrisStore();
    DateTime _currentBackPressTime;
    final GlobalKey<State> _keyHomeLoader = new GlobalKey<State>();
    ApiServiceUtils _apiServiceUtils = ApiServiceUtils();
    int responseCode = 0;
    String stResponseMessage;
    List<ResponseDtlDataAbsent> list = List();

    @override
    void initState() {
      super.initState();
      Future<String> authUn = _hrisStore.getAuthUsername();
      authUn.then((data) {
        _messageUtil.toastMessage("Welcome User " +data.trim());
      },onError: (e) {
        _messageUtil.toastMessage(e);
      });
    }

    Widget _initListAbsent(){
      return Container(
          child: listAbsents.length > 0  ?
          ListView.builder(
              itemCount: listAbsents.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  child: ListAdapter(modelAbsensi: listAbsents[index]),
                  onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => DetailAbsentActivity(absensiModel: listAbsents[index]),
                      ),
                    );
  //                  Scaffold.of(context).showSnackBar(SnackBar(
  //                    content: Text(listAbsents[index].dateAbsent),
  //                  ));
                  },
                );
  //              return Dismissible(
  //                onDismissed: (DismissDirection direction) {
  //                  setState(() {
  //                    listAbsents.removeAt(index);
  //                  });
  //                },
  //                secondaryBackground: Container(
  //                  child: Center(
  //                    child: Text(
  //                      'Delete',
  //                      style: TextStyle(color: Colors.white),
  //                    ),
  //                  ),
  //                  color: Colors.red,
  //                ),
  //                background: Container(),
  //                child: ListAdapter(modelAbsensi: listAbsents[index]),
  //                key: UniqueKey(),
  //                direction: DismissDirection.endToStart,
  //              );
              }
          ) : Center(child: Text('No Data Found')),
      );
    }

    Future<bool> onWillPop() {
      DateTime now = DateTime.now();
      if (_currentBackPressTime == null ||
          now.difference(_currentBackPressTime) > Duration(seconds: 2)) {
        _currentBackPressTime = now;
        _messageUtil.toastMessage("please tap again to exit");
        return Future.value(false);
      }
      return SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }

    @override
    Widget build(BuildContext context) {
      return WillPopScope(
        onWillPop: onWillPop,
        child: new Scaffold(
          appBar: new AppBar(
            title: new Text(
              "Home",
              style: new TextStyle(color: Colors.white),
            ),
          ),
          body: _initListAbsent(), floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => DetailAbsentActivity(absensiModel: null),
                      ),
                    );
                },
              ),
        ),
      );
    }
    Future<ResponseDataAbsent> _loadAbsent(BuildContext context) async {
      try{
        LoadingUtils.showLoadingDialog(context, _keyHomeLoader);
        _apiServiceUtils.getDataAbsen(_hrisStore.getAuthUserId().toString(),
            _hrisStore.getAuthToken().toString()).then((value) => {
              responseCode = ResponseDataAbsent.fromJson(jsonDecode(value)).code,
              Navigator.of(_keyHomeLoader.currentContext,rootNavigator: true).pop(),
              if(responseCode == ConstanstVar.successCode){
                  list = ResponseDataAbsent.fromJson(jsonDecode(value)).responseDtlDataAbsent,
              }else if(responseCode == ConstanstVar.invalidTokenCode){
                stResponseMessage = ErrorResponse.fromJson(jsonDecode(value)).message,
                _messageUtil.toastMessage("$stResponseMessage"),
                new Future.delayed(const Duration(seconds: 4), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginActivity()),
                    );
                }),
              }else{
                stResponseMessage = ErrorResponse.fromJson(jsonDecode(value)).message,
                _messageUtil.toastMessage("$stResponseMessage")
              }
        });
      }catch(error){
        Navigator.of(_keyHomeLoader.currentContext,rootNavigator: true).pop();
        _messageUtil.toastMessage("err Login " +error.toString());
      }
      return null;
    }

}


