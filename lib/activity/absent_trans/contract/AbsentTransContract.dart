import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:absent_hris/model/MasterAbsent/GetAbsent/ResponseDtlAbsentModel.dart';

class AbsentTransInteractor{
    void validateConn(BuildContext context) {}
    void validateConnSubmit(BuildContext context) {}
    void toSubmitAbsent(){}
    void getCoordinat(Geolocator geolocator, BuildContext context){}
    void getAddress(Position _position, BuildContext context){}
    void initUnIdToken(int intType){}
    void getDataAbsentOut(){}
}

class AbsentTransView{
    void validateGps(){}
    void getAbsentAddress(Position _position, BuildContext context){}
    void backScreen(){}
    void loadingUIBar(){}
    void loadingBar(int typeLoading) {}
    void initAbsentTrans(int typeInit){}
    void cantGetCoordinatAlert(BuildContext context){}
    void resultAddress(String finalAddress){}
    void snackBarMessage(String message){}
    void toastMessage(String theMessage){}
    void closeAlert(BuildContext context){}
}