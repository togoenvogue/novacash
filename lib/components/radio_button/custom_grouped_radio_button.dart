import 'package:flutter/material.dart';
import 'custom_grouped_radio_button_item.dart';

class CustomGroupedRadioButton extends StatelessWidget {
  final Function callBack;
  final List<String> options;

  CustomGroupedRadioButton({this.callBack, this.options});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40 * options.length / 2,
      child: GridView.count(
        scrollDirection: Axis.vertical,
        crossAxisCount: 2,
        childAspectRatio: 4,
        children: List.generate(options.length, (index) {
          return CustomGroupedRadioButtonItem(
            callBack: callBack,
            label: options[index],
            index: index,
          );
        }),
      ),
    );
  }
}
