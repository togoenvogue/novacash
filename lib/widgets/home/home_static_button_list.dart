import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
  _downloadPDF() async {
    if (await canLaunch('https://mastercash.network/_novacash/NovaCash.pdf')) {
      await launch('https://mastercash.network/_novacash/NovaCash.pdf');
    } else {
      throw 'Could not launch $widget.url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HomeStaticButtonItem(
              label: 'Télécharger',
              image: Image.asset('assets/images/icon-pdf.png'),
              callBack: _downloadPDF,
              isClickable: true,
              screen: null,
            ),
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
