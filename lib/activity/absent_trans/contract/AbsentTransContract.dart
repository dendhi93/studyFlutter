import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class AbsentTransInteractor{
    void validateConn(BuildContext context) {}
    void validateConnSubmit(BuildContext context) {}
    void toSubmitAbsent(){}
    void getCoordinat(Geolocator geolocator, BuildContext context){}
    void getAddress(Position _position, BuildContext context){}
    void initUnIdToken(int intType, String reasonAbsent,
        String address,String dateAbsent, int groupValue, String inputTime){}
    void getDataAbsentOut(){}
    void interactorLoading(){}
    void validateGpsService(BuildContext context){}
}

class AbsentTransView{
    void alertGpsOff(){}
    void backScreen(){}
    void loadingUIBar(){}
    void loadingBar(int typeLoading) {}
    void initAbsentTrans(int typeInit){}
    void resultAddress(String finalAddress){}
    void snackBarMessage(String message){}
    void toastMessage(String theMessage){}
    void closeAlert(BuildContext context){}
    void noConnectionAlert(String titleMsg, titleContent,BuildContext context){}
    void paramAbsent(String paramAbsentIn, String paramAbsentOut){}
}