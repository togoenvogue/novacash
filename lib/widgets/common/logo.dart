import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(
        'assets/images/novabets_logo.png',
        height: 65,
      ),
    );
  }
}