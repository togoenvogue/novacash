import 'package:flutter/material.dart';
import '../../styles/styles.dart';

class DrawerListItem extends StatelessWidget {
  final String label;
  final String imageUrl;
  final dynamic screen;
  final Function callBack;
  DrawerListItem({this.label, this.imageUrl, this.callBack, this.screen});

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
                height: 45,
              ),
              Text(
                label,
                style: TextStyle(
                  fontFamily: MyFontFamily().family2,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      //height: 50,
      margin: EdgeInsets.all(8),
    );
  }
}
