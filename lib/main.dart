import 'package:absent_hris/model/ModelAbsensi.dart';
import 'package:flutter/material.dart';

import 'list_absent_adapter/list_absent_adapter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AbsentHris',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Absent HRIS'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<ModelAbsensi> listAbsents = [
    ModelAbsensi(dayAbsent: 'Monday', dateIn: '2020-07-20 07:00', dateOut: '2020-07-20 12:00', reason: ''),
    ModelAbsensi(dayAbsent: 'Tuesday', dateIn: '2020-07-21 06:30', dateOut: '2020-07-20 12:00', reason: ''),
    ModelAbsensi(dayAbsent: 'Wednesday', dateIn: '2020-07-22 07:10', dateOut: '2020-07-20 12:00', reason: 'Late'),
    ModelAbsensi(dayAbsent: 'Thursday', dateIn: '2020-07-23 07:00', dateOut: '2020-07-20 17:00', reason: 'Meetings'),
  ];

  Widget _initListAbsent(){
    return Container(
        child: listAbsents.length > 0  ?
        ListView.builder(
            itemCount: listAbsents.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: ListAdapter(modelAbsensi: listAbsents[index]),
                onTap: () => Scaffold
                    .of(context)
                    .showSnackBar(SnackBar(content: Text(listAbsents[index].dayAbsent))),
              );
//              for swipe delete
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
//              
            }
        ) : Center(child: Text('No Data Found'))
    );
  }

  @override
  Widget build(BuildContext context) {
//    var androidVersions = [
//      "Android Cupcake",
//      "Android Donut",
//      "Android Eclair",
//      "Android Froyo",
//      "Android Gingerbread",
//      "Android Honeycomb",
//      "Android Ice Cream Sandwich",
//      "Android Jelly Bean",
//      "Android Kitkat",
//      "Android Lollipop",
//      "Android Marshmallow",
//      "Android Nougat",
//      "Android Oreo",
//      "Android Pie"
//    ];

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: _initListAbsent(),
//        body: ListView.builder(
//          itemBuilder: (context, position) {
//            return Card(
//              child : Padding(
//                padding: EdgeInsets.all(12.0),
//                child: Text(androidVersions[position]),
//              )
//            );
//          },
//          itemCount: androidVersions.length,
//        ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}


