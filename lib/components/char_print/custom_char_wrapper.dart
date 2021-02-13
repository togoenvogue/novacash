import 'package:flutter/material.dart';

class CustomCharWrapper extends StatelessWidget {
  final Widget child;
  final Function reset;
  CustomCharWrapper({this.child, this.reset});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      children: [
        InkWell(
          onTap: () {
            reset();
          },
          splashColor: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomLeft: Radius.circular(12),
          ),
          child: Container(
            child: Icon(
              Icons.clear,
              size: 35,
              color: Colors.white,
            ),
            width: 50,
            height: 55,
            decoration: BoxDecoration(
              color: Color(0xffF61E1E).withOpacity(0.7),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: child,
            ),
            height: 55,
            decoration: BoxDecoration(
              color: Color(0xff404A6B).withOpacity(1),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
