import 'package:flutter/material.dart';

class CharWrapper extends StatelessWidget {
  final Widget child;
  final Function reset;
  CharWrapper({this.child, this.reset});
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
            topLeft: Radius.circular(6),
            bottomLeft: Radius.circular(6),
          ),
          child: Container(
            child: Icon(
              Icons.clear,
              size: 25,
              color: Colors.white,
            ),
            width: 50,
            height: 35,
            decoration: BoxDecoration(
              color: Color(0xffF61E1E).withOpacity(0.7),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6),
                bottomLeft: Radius.circular(6),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              child: child,
            ),
            height: 35,
            decoration: BoxDecoration(
              color: Color(0xff404A6B).withOpacity(0.8),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(6),
                bottomRight: Radius.circular(6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
