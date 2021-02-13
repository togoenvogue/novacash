import 'package:flutter/material.dart';
import '../../styles/styles.dart';

class Paragraph extends StatelessWidget {
  final String text;
  Paragraph({this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        text,
        style: MyStyles().paragraph,
      ),
      margin: EdgeInsets.only(
        bottom: 15,
      ),
    );
  }
}
