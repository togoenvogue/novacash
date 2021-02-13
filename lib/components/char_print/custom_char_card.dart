import 'package:flutter/material.dart';
import '../../styles/styles.dart';

class CustomCharCard extends StatelessWidget {
  final dynamic char;
  final double fontSize;
  CustomCharCard({
    this.char,
    this.fontSize = 23,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 2),
      curve: Curves.bounceInOut,
      margin: EdgeInsets.all(2),
      width: 40,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2),
        child: Text(
          char.toString(),
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Color(0xffffffff),
            fontFamily: MyFontFamily().family2,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      decoration: BoxDecoration(
        color: MyColors().primary,
        //color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
