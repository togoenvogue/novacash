import 'package:flutter/material.dart';

class CustomFlatButtonRounded extends StatelessWidget {
  final String label;
  final Function function;
  final double borderRadius;
  final Color bgColor;
  final Color textColor;
  final Color borderColor;
  final bool isBold;

  CustomFlatButtonRounded({
    this.bgColor,
    this.textColor,
    this.borderRadius,
    this.function,
    this.label,
    this.borderColor = Colors.white,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0),
              blurRadius: 15.0, // soften the shadow
              spreadRadius: 1.0, //extend the shadow
              offset: Offset(
                1.0, // Move to right 10  horizontally
                1.0, // Move to bottom 10 Vertically
              ),
            )
          ],
        ),
        child: FlatButton(
          minWidth: double.infinity,
          padding: EdgeInsets.fromLTRB(0, 9, 0, 12),
          color: bgColor,
          onPressed: function,
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 15,
              fontWeight: isBold == true ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(
              width: 1,
              color: borderColor.withOpacity(0.2),
            ),
          ),
        ),
      ),
    );
  }
}
