import 'package:flutter/material.dart';
import '../../styles/styles.dart';

class CharCard extends StatelessWidget {
  final String char;
  CharCard({this.char});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 2),
      curve: Curves.bounceInOut,
      margin: EdgeInsets.all(2),
      //width: 30,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2),
        child: Text(
          char,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.normal,
            color: Color(0xffffffff),
            fontFamily: MyFontFamily().family3,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      decoration: BoxDecoration(
        //color: MyColors().primary,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
