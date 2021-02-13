import 'package:flutter/material.dart';
import '../../styles/styles.dart';

class KeyStroke extends StatelessWidget {
  final int number;
  final Function keyFnc;
  KeyStroke({this.number, this.keyFnc});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(0),
      splashColor: Colors.red,
      onTap: () {
        if (number != null && number >= 0) {
          keyFnc(keyStroke: number);
        }
      },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 3.0,
            horizontal: 1,
          ),
          child: Text(
            number.toString(),
            style: TextStyle(
              fontSize: 27,
              color: Color(0xffffffff),
              fontFamily: MyFontFamily().family3,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        /*decoration: BoxDecoration(
          color: Color(0xffFFFFFF).withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
        ),*/
        margin: EdgeInsets.all(2),
      ),
    );
  }
}
