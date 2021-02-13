import 'package:flutter/material.dart';

class TopAppBar extends StatelessWidget {
  final String label;
  TopAppBar({this.label});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'betNino',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Color(0xff5A73CB),
      iconTheme: IconThemeData(color: Colors.white),
      shadowColor: Colors.transparent,
    );
  }
}
