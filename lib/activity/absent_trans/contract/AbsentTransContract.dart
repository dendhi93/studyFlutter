import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:absent_hris/model/MasterAbsent/GetAbsent/ResponseDtlAbsentModel.dart';

class AbsentTransInteractor{
    void validateConn(BuildContext context) {}
    void validateConnSubmit(BuildContext context) {}
    void toSubmitAbsent(){}
    void getCoordinat(Geolocator geolocator, BuildContext context){}
    void getAddress(Position _position, BuildContext context){}
}

class AbsentTransView{
    void validateGps(){}
    void getAbsentAddress(Position _position, BuildContext context){}
    void loadingBar(){}
    void backScreen(){}
    void loadingUIBar(){}
    void loadingBar(int typeLoading) {}
    void initAbsentTrans(int typeInit){}
    void cantGetCoordinatAlert(BuildContext context){}
    void resultAddress(String finalAddress){}
}