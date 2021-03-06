import 'package:flutter/material.dart';

import '../../../models/category.dart';
import '../../../styles/styles.dart';

class UserSettingsList extends StatefulWidget {
  final Function callBack;
  final CategoryModel category;
  UserSettingsList({this.callBack, this.category});

  @override
  _UserSettingsListState createState() => _UserSettingsListState();
}

class _UserSettingsListState extends State<UserSettingsList> {
  bool _isChecked = false;
  List<int> positions = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.category.category,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: MyFontFamily().family1,
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  child: Checkbox(
                    checkColor: Colors.green,
                    activeColor: Colors.white,
                    value: _isChecked,
                    onChanged: (bool value) {
                      setState(() {
                        _isChecked = value;
                        widget.callBack(
                          isSelected: value,
                          categoryKey: '"${widget.category.key}"',
                        );
                      });
                    },
                  ),
                  width: 35,
                ),
              ],
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.10),
            width: 1,
          ),
        ),
      ),
    );
  }
}
