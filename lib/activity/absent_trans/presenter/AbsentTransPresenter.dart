import 'dart:convert';
import 'dart:core';

import 'package:absent_hris/activity/absent_trans/contract/AbsentTransContract.dart';
import 'package:absent_hris/model/ErrorResponse.dart';
import 'package:absent_hris/model/MasterAbsent/PostAbsent/PostJsonAbsent.dart';
import 'package:absent_hris/model/MasterAbsentOut/ResponseAbsentOut.dart';
import 'package:absent_hris/util/ApiServiceUtils.dart';
import 'package:absent_hris/util/ConstantsVar.dart';
import 'package:absent_hris/util/HrisStore.dart';
import 'package:absent_hris/util/HrisUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';


class AbsentTransPresenter implements AbsentTransInteractor{
  HrisStore hrisStore = HrisStore();
  ApiServiceUtils apiServiceUtils = ApiServiceUtils();
  AbsentTransView view;
  AbsentTransPresenter(this.view);
  int responseCode = 0;
  String stResponseMessage = "";
  String stUid = "";
  String stToken = "";
  String _stAbsentLat = "";
  String _stAbsentLongitude = "";
  Position _currentPosition;

  @override
  void toSubmitAbsent() async {
    // implement toSubmitAbsent
  }

  @override
  void validateConn(BuildContext context) {
    // implement validateConn
    HrisUtil.checkConnection().then((isConnected) => {
      isConnected ? getDataAbsentOut() : view?.noConnectionAlert(ConstanstVar.noConnectionTitle, ConstanstVar.noConnectionMessage, context)
    });
  }


  @override
  void validateConnSubmit(BuildContext context) {
    // implement validateConnSubmit
  }

  @override
  void getCoordinat(Geolocator geolocator, BuildContext context) async {
    // implement getCoordinat
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
          if(_currentPosition != null)getAddress(position, context);
          view?.loadingUIBar();
    }).catchError((e) {
      print(e);
      view?.loadingUIBar();
    });
  }

  @override
  void getAddress(Position _position, BuildContext context) async {
    try{
      final coordinates = new Coordinates(_position.latitude, _position.longitude);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      print("${first.featureName} : ${first.addressLine}");
      view?.resultAddress(first.addressLine);
    }catch(error){
      print(error.toString());
      view?.toastMessage("please refresh coordinat");
    }
  }

  @override
  void initUnIdToken(int intType,String reasonAbsent,String address,String dateAbsent) async{
    // implement initUnIdToken
    if(intType == 1){
      Future<String> authUid = hrisStore.getAuthUserId();
      authUid.then((data) {
        stUid = data.trim();
        initUnIdToken(2);
      },onError: (e) {view?.toastMessage(e);});
    }else{
      Future<String> authUToken = hrisStore.getAuthToken();
      authUToken.then((data) {
        stToken = data.trim();
        stUid = stUid+"-"+stToken;
        if(_currentPosition != null){
          _stAbsentLat = _currentPosition.latitude.toString();
          _stAbsentLongitude = _currentPosition.longitude.toString();
        }
        PostJsonAbsent _postJsonAbsent =
        PostJsonAbsent(userId: stUid,absentType: _groupValue.toString(),
            addressAbsent: address.trim(),reason: reasonAbsent,
            dateAbsent: dateAbsent.trim(),absentLat: _stAbsentLat,
            absentLongitude: _stAbsentLongitude, absentTime: etInputTime.text.toString());

        print(PostJsonAbsent().absentToJson(_postJsonAbsent));
        // _submitAbsent(context, _postJsonAbsent);
      },onError: (e) {view?.toastMessage(e);});
    }
  }

  @override
  void getDataAbsentOut() async {
    interactorLoading();
    apiServiceUtils.getMasterAbsentOut(interactorLoading).then((value) => {
      print(jsonDecode(value)),
      responseCode = ResponseAbsentOut.fromJson(jsonDecode(value)).code,
      if(responseCode == ConstanstVar.successCode){
        // stAbsentOut = ResponseAbsentOut.fromJson(jsonDecode(value)).absentOut,
        // stAbsentIn = ResponseAbsentOut.fromJson(jsonDecode(value)).absentIn,
      }else{
        stResponseMessage = ErrorResponse.fromJson(jsonDecode(value)).message,
        view?.toastMessage("$stResponseMessage"),
      }
    });

  }

  @override
  void interactorLoading() => view?.loadingUIBar();

  @override
  void validateGpsService(BuildContext context) async{
    // implement validateGpsService
    view?.loadingUIBar();
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    if(!(await Geolocator().isLocationServiceEnabled())){
      view?.loadingUIBar();
      view?.alertGpsOff();
    }
    else{getCoordinat(geolocator, context);}
  }

}