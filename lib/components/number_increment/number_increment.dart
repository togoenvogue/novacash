import 'package:flutter/material.dart';

class CustomNumberIncrement extends StatefulWidget {
  final Color textColor;
  final int interval;
  final int defaultValue;
  final int minValue;
  final int maxValue;
  final Function callBack;
  CustomNumberIncrement({
    this.textColor = Colors.black,
    this.interval = 1,
    this.defaultValue = 0,
    this.minValue = 0,
    this.maxValue = 99,
    this.callBack,
  });
  @override
  _CustomNumberIncrementState createState() => _CustomNumberIncrementState();
}

class _CustomNumberIncrementState extends State<CustomNumberIncrement> {
  int _number;

  void _setNumber(String direction) {
    setState(() {
      if (direction == 'UP') {
        if (_number < widget.maxValue) {
          _number = _number + widget.interval;
        }
      } else {
        if (_number > widget.minValue) {
          _number = _number - widget.interval;
        }
      }
      widget.callBack(_number);
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _number = widget.defaultValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            child: InkWell(
              splashColor: Colors.white,
              onTap: () {
                _setNumber('DOWN');
              },
              child: Icon(
                Icons.remove_circle_outline,
                color: Colors.black.withOpacity(
                  0.3,
                ),
              ),
            ),
          ),
          Container(
            width: 100,
            child: Text(
              _number.toString(),
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.normal,
                color: widget.textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: 50,
            child: InkWell(
              splashColor: Colors.white,
              onTap: () {
                _setNumber('UP');
              },
              child: Icon(
                Icons.add_circle_outline,
                color: Colors.black.withOpacity(
                  0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
