

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailAbsentActivity extends StatelessWidget {

  Widget _initDetail(){
    return Container(
      padding: EdgeInsets.all(12.0),
      child: Text('Flat Button'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Absent'),
      ),
      body: _initDetail(),
    );
  }
}