import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';
import '../../styles/styles.dart';

class HomeStaticButtonItem extends StatelessWidget {
  final String label;
  final Image image;
  final Function callBack;
  final dynamic screen;
  final bool isClickable;

  HomeStaticButtonItem({
    this.callBack,
    this.image,
    this.label,
    this.screen,
    this.isClickable = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isClickable == true && screen != null) {
          Navigator.of(context).push(
            CubePageRoute(
              enterPage: screen,
              exitPage: screen,
              duration: const Duration(milliseconds: 300),
            ),
          );
        } else {
          callBack();
        }
      },
      splashColor: Colors.white,
      //highlightColor: Colors.pink,
      borderRadius: BorderRadius.circular(10),

      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
        child: Column(
          children: [
            Container(
              /*decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 15.0, // soften the shadow
                    spreadRadius: 1.0, //extend the shadow
                    offset: Offset(
                      1.0, // Move to right 10  horizontally
                      1.0, // Move to bottom 10 Vertically
                    ),
                  )
                ],
              ),*/
              child: image,
              width: 40,
            ),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: MyFontFamily().family2,
                color: MyColors().primary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
