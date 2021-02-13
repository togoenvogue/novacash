import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget content;
  final color;
  CustomCard({this.content, this.color = const Color(0xffffff)});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: content,
        decoration: BoxDecoration(
          color: color.withOpacity(1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 2, // soften the shadow
              spreadRadius: 0, //extend the shadow
              offset: Offset(
                0.1, // Move to right 10  horizontally
                0.1, // Move to bottom 10 Vertically
              ),
            ),
          ],
          borderRadius: BorderRadius.circular(15),
        ),
        margin: EdgeInsets.all(2),
      ),
    );
  }
}
