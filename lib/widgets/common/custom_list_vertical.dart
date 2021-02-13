import 'package:flutter/material.dart';
import '../../styles/styles.dart';

class CustomListVertical extends StatelessWidget {
  final String label;
  final String value;
  final bool valueIsBold;
  CustomListVertical({this.label, this.value, this.valueIsBold = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: !valueIsBold ? FontWeight.bold : FontWeight.normal,
                fontFamily: MyFontFamily().family2,
                fontSize: 16,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: MyColors().primary,
                fontWeight: valueIsBold ? FontWeight.bold : FontWeight.normal,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
