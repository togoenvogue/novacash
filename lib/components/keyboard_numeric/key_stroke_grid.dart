import 'package:flutter/material.dart';
import '../../styles/styles.dart';

class KeyStrokeGrid extends StatelessWidget {
  final int number;
  final Function keyFnc;
  KeyStrokeGrid({this.keyFnc, this.number});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(1.5),
      child: InkWell(
        borderRadius: BorderRadius.circular(0),
        splashColor: Colors.white,
        onTap: () {
          if (number != null && number >= 0) {
            keyFnc(keyStroke: number);
          }
        },
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 6.0,
              horizontal: 1,
            ),
            child: Text(
              number.toString(),
              style: TextStyle(
                fontSize: 20,
                color: Color(0xffffffff),
                fontFamily: MyFontFamily().family2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          decoration: BoxDecoration(
            color: Color(0xffFFFFFF).withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
