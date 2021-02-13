import 'package:flutter/material.dart';
import '../../styles/styles.dart';

class CustomNote extends StatelessWidget {
  final String message;
  final Color color;
  final IconData icon;
  CustomNote({this.icon, this.message, this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 25,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
              size: 30,
              color: color,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 3,
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    color: color,
                    fontFamily: MyFontFamily().family2,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
