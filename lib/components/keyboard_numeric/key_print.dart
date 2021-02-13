import 'package:flutter/material.dart';
import '../../components/char/char_list.dart';
import '../../components/char/char_wrapper.dart';

class KeyPrint extends StatefulWidget {
  final int keyStroke;
  final Function callBak;
  KeyPrint({this.keyStroke, this.callBak});
  @override
  _KeyPrintState createState() => _KeyPrintState();
}

class _KeyPrintState extends State<KeyPrint> {
  //List<String> _charsList = [];
  List<String> _charsListCopy = [];
  //final bool _maskChar = true;

/*
  void _getKeyStroke({int keyStroke}) {
    if (_charsList.length < 5) {
      setState(() {
        _charsList.add(keyStroke.toString());
        if (_maskChar == true) {
          _charsListCopy.add('#');
        } else {
          _charsListCopy.add(keyStroke.toString());
        }
      });
    } else {
      setState(() {
        _charsList = [];
        _charsListCopy = [];
      });
    }
  }
*/

  void _resetCharList() {
    setState(() {
      // _charsList = [];
      _charsListCopy = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return CharWrapper(
      reset: _resetCharList,
      child: CharList(
        charCount: _charsListCopy.length,
        charsArray: _charsListCopy,
      ),
    );
  }
}
