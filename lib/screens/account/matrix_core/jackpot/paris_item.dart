import 'package:flutter/material.dart';
import '../../../../styles/styles.dart';

class MesParisJackpotListItem extends StatelessWidget {
  final String label;
  final String value;
  MesParisJackpotListItem({this.label, this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: MyColors().primary,
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.black.withOpacity(0.1),
          ),
        ),
      ),
      padding: EdgeInsets.all(6),
    );
  }
}
