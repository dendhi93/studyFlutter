
import 'file:///D:/project/flutter/lib/model/Master_UnAttendance/GetUnAttendance/ResponseDtlUnAttendance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UnAttendanceTransActivity extends StatefulWidget {
  final ResponseDtlUnAttendance unAttendanceModel;
  UnAttendanceTransActivity({Key key, @required this.unAttendanceModel}) : super(key: key);

  @override
  _UnAttendanceTransActivityState createState() => _UnAttendanceTransActivityState();
}

class _UnAttendanceTransActivityState extends State<UnAttendanceTransActivity> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController etStartDate = new TextEditingController();
  TextEditingController etEndDate = new TextEditingController();
  TextEditingController etQtyDate = new TextEditingController();


  @override
  void initState() {
    super.initState();
    if(widget.unAttendanceModel != null){
      etStartDate.text = widget.unAttendanceModel.startDate;
      etEndDate.text = widget.unAttendanceModel.endDate;
      etQtyDate.text = widget.unAttendanceModel.qtyDate.toString();
    }
  }

  //view
  Widget _initUnAttendance(BuildContext buildContext){
    return Form(
      key: _formKey,
        child: new Container(
          padding: const EdgeInsets.all(10.0),
            child: new Center(
                child: new Column(
                    children: <Widget>[
                      new Padding(padding: EdgeInsets.only(top: 10.0)),
                      new TextFormField(
                        enabled: false,
                        controller: etStartDate,
                        // onTap: (){
                        //   FocusScope.of(context).requestFocus(new FocusNode());
                        //     _selecDatePicker(context);
                        // },
                        decoration: new InputDecoration(
                          labelText: "Start Date",
                          contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(15.0),
                            borderSide: new BorderSide(
                            ),
                          ),
                        ),
                        validator: (val) {
                          if(val.length==0) {return "Date cannot be empty";
                          }else{return null;}
                        },
                        keyboardType: TextInputType.datetime,
                        style: new TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                      new Padding(padding: EdgeInsets.only(top: 10.0)),
                      new TextFormField(
                        enabled: false,
                        controller: etEndDate,
                        // onTap: (){
                        //   FocusScope.of(context).requestFocus(new FocusNode());
                        //     _selecDatePicker(context);
                        // },
                        decoration: new InputDecoration(
                          labelText: "End Date",
                          contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(15.0),
                            borderSide: new BorderSide(
                            ),
                          ),
                        ),
                        validator: (val) {
                          if(val.length==0) {return "Date cannot be empty";
                          }else{return null;}
                        },
                        keyboardType: TextInputType.datetime,
                        style: new TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                      new Padding(padding: EdgeInsets.only(top: 10.0)),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Container(
                              width: 120,
                              child: new TextFormField(
                                enabled: false,
                                controller: etQtyDate,
                                // onTap: (){
                                //   FocusScope.of(context).requestFocus(new FocusNode());
                                //     _selecDatePicker(context);
                                // },
                                decoration: new InputDecoration(
                                  labelText: "Qty Date",
                                  contentPadding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                                  fillColor: Colors.white,
                                  border: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(15.0),
                                    borderSide: new BorderSide(
                                    ),
                                  ),
                                ),
                                validator: (val) {
                                  if(val.length==0) {return "Date cannot be empty";
                                  }else{return null;}
                                },
                                keyboardType: TextInputType.number,
                                style: new TextStyle(
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ),
                          ]
                      ),
                    ]
                ),
            ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UnAttendance Plan'),
      ),
      body: _initUnAttendance(context)
    );
  }
}
