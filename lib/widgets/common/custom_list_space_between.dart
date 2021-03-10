import 'package:flutter/material.dart';
import '../../styles/styles.dart';

class CustomListSpaceBetwen extends StatelessWidget {
  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;
  final double valueFontSize;
  CustomListSpaceBetwen({
    this.label,
    this.value,
    this.labelColor = Colors.black87,
    this.valueColor = Colors.black87,
    this.valueFontSize = 13.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontFamily: MyFontFamily().family1,
              fontSize: valueFontSize,
            ),
          ),
          SelectableText(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: valueFontSize,
              fontFamily: MyFontFamily().family1,
            ),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
    );
  }
}
