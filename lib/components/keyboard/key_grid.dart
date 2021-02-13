import 'package:flutter/material.dart';
import '../../styles/styles.dart';

class KeyStrokeGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4.0,
          horizontal: 20,
        ),
        child: Text(
          '1',
          style: TextStyle(
            fontSize: 30,
            color: Color(0xffffffff),
            fontFamily: MyFontFamily().family4,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      decoration: BoxDecoration(
        color: Color(0xffFFFFFF).withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
