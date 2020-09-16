
import 'package:absent_hris/activity/DetailAbsentActivity.dart';
import 'package:absent_hris/list_adapter/list_absent_adapter.dart';
import 'package:absent_hris/model/ModelAbsensi.dart';
import 'package:absent_hris/util/HrisStore.dart';
import 'package:absent_hris/util/MessageUtil.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomeActivity extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _HomeActivityState createState() => _HomeActivityState();
}


class _HomeActivityState extends State<HomeActivity> {
  List<ModelAbsensi> listAbsents = [
    ModelAbsensi(dateAbsent: '2020-07-20', timeIn: '07:00', timeOut: '12:00', reason: '', addressAbsent :'Multivision Tower'),
    ModelAbsensi(dateAbsent: '2020-07-21', timeIn: '06:30', timeOut: '12:00', reason: '',addressAbsent :'Multivision Tower'),
    ModelAbsensi(dateAbsent: '2020-07-23', timeIn: '07:10', timeOut: '12:00', reason: 'Late',addressAbsent :'Plaza Kuningan'),
    ModelAbsensi(dateAbsent: '2020-07-24', timeIn: '07:00', timeOut: '17:00', reason: 'Meetings',addressAbsent :'Multivision Tower'),
  ];
  MessageUtil messageUtil = MessageUtil();
  HrisStore hrisStore = HrisStore();

  @override
  void initState() {
    super.initState();
    Future<String> authUn = hrisStore.getAuthUsername();
    authUn.then((data) {
      messageUtil.toastMessage("Welcome User " +data.trim());
    },onError: (e) {
      messageUtil.toastMessage(e);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: _initListAbsent(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => DetailAbsentActivity(absensiModel: null),
              ),
            );
          // Fluttertoast.showToast(
          //     msg: "Test",
          //     toastLength: Toast.LENGTH_LONG,
          //     gravity: ToastGravity.CENTER,
          //     timeInSecForIosWeb: 1,
          //     backgroundColor: Colors.blue,
          //     textColor: Colors.white,
          //     fontSize: 16.0
          // );
        },
      ),
    );
  }
}


