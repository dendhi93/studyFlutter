import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomSubmitButton extends StatefulWidget {
  String title;
  CustomSubmitButton({@required this.onPressed, this.title});
  final GestureTapCallback onPressed;

  @override
  _AbsentTransActivityState createState() => _AbsentTransActivityState();
}
  class _AbsentTransActivityState extends State<CustomSubmitButton> {
    String _finalTitle;
    @override
    void initState() {
      super.initState();
      _finalTitle = widget.title;
    }

    @override
    Widget build(BuildContext context) {
      return RawMaterialButton(
        fillColor: Colors.blue,
        splashColor: Colors.greenAccent,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const <Widget>[
              Text(
                "",
                maxLines: 1,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        onPressed: widget.onPressed,
        shape: const StadiumBorder(),
      );
    }
  }




