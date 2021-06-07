import 'dart:convert';

import 'package:absent_hris/activity/absent_trans/contract/AbsentTransContract.dart';
import 'package:absent_hris/model/ErrorResponse.dart';
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
  void initUnIdToken(int intType) {
    // implement initUnIdToken

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

}