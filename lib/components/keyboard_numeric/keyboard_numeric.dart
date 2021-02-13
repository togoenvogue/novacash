import 'package:flutter/material.dart';
import '../../components/keyboard_numeric/key_stroke_grid.dart';
import '../../components/keyboard_numeric/key_print.dart';
import '../../styles/styles.dart';

class KeyBoardNumeric extends StatelessWidget {
  final int keyCount;
  final Function keyFnc;
  final bool excludeZero;
  final String title;

  KeyBoardNumeric({this.keyCount, this.keyFnc, this.excludeZero, this.title});

  void printKeyStroke({int keyStroke}) {
    //print(keyStroke);
  }

  @override
  Widget build(BuildContext context) {
    double keyBoardHeight;
    if (keyCount > 0 && keyCount <= 7) {
      keyBoardHeight = 47;
    } else if (keyCount > 7 && keyCount <= 14) {
      keyBoardHeight = 96;
    } else if (keyCount > 14 && keyCount <= 21) {
      keyBoardHeight = 142;
    } else {
      keyBoardHeight = 142;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Column(
        children: [
          KeyPrint(
            callBak: () {},
            keyStroke: 0,
          ),
          SizedBox(height: 7),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              children: [
                Text(
                  title.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: MyFontFamily().family2,
                    fontSize: 17,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  // height: 100 * (keyCount / 14), // 20
                  height: keyBoardHeight,
                  child: GridView.count(
                    scrollDirection: Axis.vertical,
                    crossAxisCount: 7,
                    children: List.generate(
                        excludeZero ? keyCount : keyCount + 1, (index) {
                      return KeyStrokeGrid(
                        number: excludeZero ? index + 1 : index,
                        keyFnc: printKeyStroke,
                      );
                    }),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Color(0xff404A6B).withOpacity(1),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
      ),
    );
  }
}
