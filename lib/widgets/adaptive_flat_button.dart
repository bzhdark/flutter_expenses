import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class AdaptiveFlatButton extends StatelessWidget {
  final String text;
  final Function action;

  AdaptiveFlatButton(this.text, this.action);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            onPressed: action,
            child: Text(
              'Choose a date',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        : FlatButton(
            textColor: Theme.of(context).primaryColor,
            onPressed: action,
            child: Text(
              'Choose a date',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          );
  }
}
