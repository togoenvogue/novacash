import 'package:flutter/material.dart';

class ButtonGrid extends StatelessWidget {
  final String text;
  final Color bgColor;
  final Color textColor;
  final Function onPressed;
  final String image;

  ButtonGrid({
    this.bgColor,
    this.onPressed,
    this.textColor,
    this.text,
    this.image,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: bgColor,
        child: FlatButton(
          padding: EdgeInsets.all(
            18.0,
          ),
          child: Column(
            children: <Widget>[
              Image(
                image: AssetImage(image),
                height: 40.0,
                color: textColor,
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15.0,
                  fontFamily: 'DaxMedium',
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
