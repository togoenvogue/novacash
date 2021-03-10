import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user.dart';
import 'drawer_core_list.dart';
import 'drawer_p2p_silver.dart';

class DrawerMain extends StatefulWidget {
  final UserModel userObj;
  DrawerMain({this.userObj});

  @override
  _DrawerMainState createState() => _DrawerMainState();
}

class _DrawerMainState extends State<DrawerMain> {
  String _matrixx;

  void _getMatrixToLoad() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs != null && prefs.getString('MATRIXX') != null) {
      setState(() {
        _matrixx = prefs.getString('MATRIXX');
      });
    } else {
      setState(() {
        _matrixx = 'PREMIUM';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getMatrixToLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Column(
            children: [
              SizedBox(height: 50),
              Image.asset(
                'assets/images/logo_app.png',
                height: 60,
              ),
              SizedBox(height: 10),
            ],
          ),
          width: double.infinity,
        ),
        //SizedBox(height: 1),
        if (_matrixx != null && _matrixx == 'PREMIUM')
          DrawerCoreList(userObj: widget.userObj),
        if (_matrixx != null && _matrixx == 'P2PSILVER')
          DrawerP2PSilverList(userObj: widget.userObj),
      ],
    );
  }
}
