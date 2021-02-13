import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final Color color;
  final Color borderColor;
  final double buttonRadius;
  final Function onPressed;

  CustomButton({
    this.text,
    this.onPressed,
    this.color,
    this.buttonRadius,
    this.textStyle,
    this.borderColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        text,
        style: textStyle,
      ),
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(buttonRadius),
        side: BorderSide(color: borderColor, width: 0.5),
      ),
      onPressed: onPressed,
      padding: EdgeInsets.only(
        top: 2.0,
        bottom: 3.0,
        left: 16.0,
        right: 16.0,
      ),
    );
  }
}
