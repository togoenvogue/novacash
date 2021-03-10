import 'package:flutter/material.dart';
import '../../styles/styles.dart';

class CustomNote extends StatelessWidget {
  final String message;
  @required
  final Color color;
  @required
  final Color textColor;
  final IconData icon;
  CustomNote({
    this.icon,
    this.message,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 8, 15, 12),
        child: Text(
          message,
          style: TextStyle(
            color: textColor,
            fontFamily: MyFontFamily().family1,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
      ),
    );
  }
}
