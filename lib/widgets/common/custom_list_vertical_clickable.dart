import 'package:flutter/material.dart';
import '../../widgets/common/custom_horizontal_diver.dart';
import '../../styles/styles.dart';

class CustomListVerticalClickable extends StatelessWidget {
  final String id;
  final String label1;
  final String label2;
  final Function callBack;
  final Color label1Color;
  final Color label2Color;

  CustomListVerticalClickable({
    this.id,
    this.label1,
    this.label2,
    this.callBack,
    this.label1Color = Colors.redAccent,
    this.label2Color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    //print(id);
    return InkWell(
      onTap: () {
        if (callBack != null) {
          callBack(id: id);
        }
      },
      splashColor: Colors.white,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 65,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        label1,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: label1Color,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 50,
                      child: Text(
                        label2,
                        style: TextStyle(
                          color: label2Color,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          fontFamily: MyFontFamily().family2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 10,
                child: callBack != null
                    ? Icon(
                        Icons.arrow_forward_ios_sharp,
                        color: Colors.black.withOpacity(0.2),
                      )
                    : Icon(
                        Icons.message,
                        color: Colors.black.withOpacity(0.2),
                      ),
              ),
              CustomHorizontalDiver(),
            ],
          ),
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black.withOpacity(0.15),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
