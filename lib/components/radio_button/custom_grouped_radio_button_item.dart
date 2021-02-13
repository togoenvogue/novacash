import '../../styles/styles.dart';
import 'package:flutter/material.dart';

class CustomGroupedRadioButtonItem extends StatefulWidget {
  final String label;
  final Function callBack;
  final int index;

  CustomGroupedRadioButtonItem({this.label, this.callBack, this.index});

  @override
  _CustomGroupedRadioButtonItemState createState() =>
      _CustomGroupedRadioButtonItemState();
}

class _CustomGroupedRadioButtonItemState
    extends State<CustomGroupedRadioButtonItem> {
  Color _selectionColor = MyColors().primary;
  Color _defaultColor = MyColors().primary.withOpacity(0.4);
  String _selectedLabel;

  //String _groupOption;

  void _isSelected(String label) {
    setState(() {
      _selectedLabel = widget.label;
      // _selectionColor = Colors.black;
      _defaultColor = Colors.red;
    });
    widget.callBack(selectedOption: widget.label);
  }

  @override
  Widget build(BuildContext context) {
    //print(_selectedLabel);
    //print(_defaultColor);
    //print(_selectionColor);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //Text('SELECTED: $_selectedLabel'),
        InkWell(
          splashColor: Colors.black,
          borderRadius: BorderRadius.circular(50),
          onTap: () {
            _isSelected(widget.label);
            setState(() {
              _defaultColor = Colors.white;
            });
          },
          child: Container(
            width: 145,
            child: Text(
              widget.label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            decoration: BoxDecoration(
              color: _selectedLabel == widget.label
                  ? _selectionColor
                  : _defaultColor,
              borderRadius: BorderRadius.circular(40),
            ),
            padding: EdgeInsets.only(top: 6, bottom: 10, left: 6, right: 6),
          ),
        ),
      ],
    );
  }
}
