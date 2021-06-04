import 'dart:html';

import 'package:absent_hris/activity/absent_trans/contract/AbsentTransContract.dart';
import 'package:absent_hris/util/ApiServiceUtils.dart';
import 'package:absent_hris/util/HrisStore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';


class AbsentTransPresenter implements AbsentTransInteractor{
  HrisStore hrisStore = HrisStore();
  ApiServiceUtils apiServiceUtils = ApiServiceUtils();
  AbsentTransView view;
  AbsentTransPresenter(this.view);

  @override
  void toSubmitAbsent() async {
    // implement toSubmitAbsent
  }

  @override
  void validateConn(BuildContext context) {
    // implement validateConn
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
    // implement getAddress
    try{
      final coordinates = new Coordinates(_position.latitude, _position.longitude);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      print("${first.featureName} : ${first.addressLine}");
      view?.resultAddress(first.addressLine);
      // if(widget.absentModel ==null){
      //   etAddressAbsent.text = "${first.addressLine}";
      // }
    }catch(error){
      print(error.toString());
      view?.toastMessage("please refresh coordinat")
    }
  }

  @override
  void initUnIdToken(int intType) {
    // implement initUnIdToken

  }

}