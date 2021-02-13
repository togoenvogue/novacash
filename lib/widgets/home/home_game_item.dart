import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';
import '../../styles/styles.dart';

class HomeGameItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final Function function;
  final Widget screen;

  HomeGameItem({
    this.title,
    this.imageUrl,
    this.function,
    this.screen,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          CubePageRoute(
            enterPage: screen,
            exitPage: screen,
            duration: const Duration(milliseconds: 300),
          ),
        );
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.all(10),
        width: 100,
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontFamily: MyFontFamily().family1,
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            SizedBox(height: 7),
            Container(
              child: Image(
                height: 70,
                image: AssetImage(imageUrl),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          /*
          border: Border.all(
            width: 1,
            color: Color(0xffE0DAA4),
          ),
          */
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
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
