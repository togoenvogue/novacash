import 'package:flutter/material.dart';

class CustomListSpaceBetwen extends StatelessWidget {
  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;
  CustomListSpaceBetwen({
    this.label,
    this.value,
    this.labelColor = Colors.black87,
    this.valueColor = Colors.black87,
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
            ),
          ),
          SelectableText(
            value,
            style: TextStyle(
              color: valueColor,
            ),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
    );
  }
}
