import 'package:flutter/material.dart';
import '../../styles/styles.dart';

class SignUpStep2Screen extends StatefulWidget {
  @override
  _SignUpStep2ScreenState createState() => _SignUpStep2ScreenState();
}

class _SignUpStep2ScreenState extends State<SignUpStep2Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Inscription Gratuite',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().primary,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: MyColors().bgColor,
      body: Container(
        child: Text('Signup here'),
      ),
    );
  }
}
