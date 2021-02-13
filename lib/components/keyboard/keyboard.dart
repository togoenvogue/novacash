import 'package:flutter/material.dart';
import '../../components/keyboard/key_stroke.dart';
import '../../styles/styles.dart';

class VirtualKeyBoard extends StatelessWidget {
  final int keyCount;
  final int crossAxisCount;
  final Function keyFnc;
  final bool excludeZero;
  final String title;
  final Color color;

  VirtualKeyBoard({
    this.keyCount,
    this.keyFnc,
    this.excludeZero,
    this.title,
    this.crossAxisCount = 8,
    this.color = const Color(0xff404A6B),
  });
  @override
  Widget build(BuildContext context) {
    double keyBoardHeight;
    if (keyCount > 0 && keyCount <= 8) {
      keyBoardHeight = 35;
    } else if (keyCount > 8 && keyCount <= 16) {
      keyBoardHeight = 80;
    } else if (keyCount > 16 && keyCount <= 32) {
      keyBoardHeight = 130;
    } else {
      keyBoardHeight = 130;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: MyFontFamily().family2,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
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
                crossAxisCount: crossAxisCount,
                children: List.generate(excludeZero ? keyCount : keyCount + 1,
                    (index) {
                  return KeyStroke(
                    number: excludeZero ? index + 1 : index,
                    keyFnc: keyFnc,
                  );
                }),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15.0, // soften the shadow
              spreadRadius: 1.0, //extend the shadow
              offset: Offset(
                1.0, // Move to right 10  horizontally
                1.0, // Move to bottom 10 Vertically
              ),
            ),
          ],
        ),
      ),
    );
  }
}
