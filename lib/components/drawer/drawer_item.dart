import 'package:flutter/material.dart';
import '../../styles/styles.dart';

class DrawerItem extends StatelessWidget {
  final String label;
  final String imageUrl;
  final dynamic screen;
  final Function callBack;
  DrawerItem({this.label, this.imageUrl, this.callBack, this.screen});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          callBack(screen: screen);
        },
        splashColor: MyColors().primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Image.asset(
                imageUrl,
                height: 40,
              ),
              Text(
                label,
                style: TextStyle(
                  fontFamily: MyFontFamily().family1,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      //height: 50,
      margin: EdgeInsets.all(0),
    );
  }
}
