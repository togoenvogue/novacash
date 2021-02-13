import 'package:flutter/material.dart';

class FlatRoundedButtonWithIcon extends StatelessWidget {
  final Color bgColor;
  final Color textColor;
  final Function onPressed;
  final Widget label;
  final Icon icon;

  FlatRoundedButtonWithIcon(
      {this.onPressed, this.icon, this.label, this.bgColor, this.textColor});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          icon,
          label,
        ],
      ),
      onPressed: onPressed,
      color: bgColor,
      textColor: textColor,
      padding: EdgeInsets.only(
        top: 15.0,
        bottom: 15.0,
        left: 25.0,
        right: 25.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
    );
  }
}
