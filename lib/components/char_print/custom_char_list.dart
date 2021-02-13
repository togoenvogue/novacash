import 'package:flutter/material.dart';
import 'custom_char_card.dart';

class CustomCharList extends StatelessWidget {
  final int charCount;
  final int crossAxisCount;
  final double fontSize;
  final List<dynamic> charsArray;

  CustomCharList({
    this.charCount,
    this.charsArray,
    this.crossAxisCount = 7,
    this.fontSize,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: double.infinity,
      child: GridView.count(
        scrollDirection: Axis.vertical,
        crossAxisCount: crossAxisCount,
        children: List.generate(charCount, (index) {
          return CustomCharCard(
            fontSize: fontSize,
            char: charsArray.length > 0 ? charsArray[index] : '',
          );
        }),
      ),
    );
  }
}
