import 'package:flutter/material.dart';

import '../../screens/public/apn/apn.dart';
import '../../models/config.dart';
import '../../screens/public/static/contact.dart';
import 'home_static_button_item.dart';

class HomeStaticButtonList extends StatefulWidget {
  final String userKey;
  final AppConfigModel app;
  HomeStaticButtonList({this.userKey, this.app});

  @override
  _HomeStaticButtonListState createState() => _HomeStaticButtonListState();
}

class _HomeStaticButtonListState extends State<HomeStaticButtonList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HomeStaticButtonItem(
              label: 'Contacts',
              image: Image.asset('assets/images/icon-support.png'),
              callBack: () {},
              isClickable: true,
              screen: ContactScreen(app: widget.app),
            ),
            HomeStaticButtonItem(
              label: 'Points focaux',
              image: Image.asset('assets/images/icon-location.png'),
              callBack: () {},
              isClickable: true,
              screen: ApnScreen(),
            ),
          ],
        ),
      ],
    );
  }
}
