import 'package:absent_hris/activity/absent_trans/contract/AbsentTransContract.dart';
import 'package:absent_hris/util/ApiServiceUtils.dart';
import 'package:absent_hris/util/HrisStore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geolocator/geolocator.dart';


class AbsentTransPresenter implements AbsentTransInteractor{
  HrisStore hrisStore = HrisStore();
  ApiServiceUtils apiServiceUtils = ApiServiceUtils();

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
  void getAddress(Position _position, BuildContext context) {
    // implement getAddress
  }

}