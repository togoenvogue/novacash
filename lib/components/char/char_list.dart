import '../../components/char/char_card.dart';
import 'package:flutter/material.dart';

class CharList extends StatelessWidget {
  final int charCount;
  final List<String> charsArray;

  CharList({this.charCount, this.charsArray});
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 30,
      child: GridView.count(
        scrollDirection: Axis.vertical,
        crossAxisCount: 9,
        children: List.generate(charCount > 0 && charCount < 5 ? charCount : 5,
            (index) {
          return CharCard(
            char: charsArray.length > 0 ? charsArray[index] : '',
          );
        }),
      ),
    );
  }
}
