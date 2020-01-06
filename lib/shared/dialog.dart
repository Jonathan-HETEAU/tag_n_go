import 'package:flutter/material.dart';
import 'package:tag_n_go/resources/app_colors.dart';

class YesNoDialoq extends StatelessWidget {
  final String title;
  final Function onYes;
  final Function onNo;

  YesNoDialoq({this.onNo, this.onYes, this.title});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
   
      title: Text(title+"?"),
      actions: <Widget>[
        FlatButton(
          child: Text("Yes"),
          onPressed: onYes,
        ),
        FlatButton(
          child: Text("No"),
          onPressed: onNo,
        ),
      ],
    );
  }
}
