import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/config.dart';
import '../../../styles/styles.dart';
import '../../../widgets/common/custom_list_vertical.dart';

class ContactScreen extends StatelessWidget {
  final AppConfigModel app;
  ContactScreen({this.app});

  _openTelegram(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Besoin d\'aide?',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().bgColor,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Image.asset(
                'assets/images/icon-support.png',
                fit: BoxFit.cover,
              ),
              //decoration: BoxDecoration(color: Colors.green),
              height: 70,
              //width: double.infinity,
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomListVertical(
                label: 'ADRESSE',
                value: '''NovaLead
Locaux EDUCOACH-BURKINA
1er arrondissement,
Av Boumédienne, 
Porte 2331, Koulouba, 
Ougadougou, Burkina Faso''',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomListVertical(
                label: 'CONTACTS',
                value: '''Email: ${app.email}
WhatsApp: ${app.phone1}''',
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomListVertical(
                label: 'WHATSAPP',
                value:
                    'Pour toute information ou assistance, discutez avec nous sur WhatsApp',
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomListVertical(
                label: 'TELEGRAM',
                value:
                    'Rejoignez notre groupe Telegram pour être informé en temps réel sur les mises à jour et les nouveautés des programmes NovaCash',
              ),
            ),
            SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        FlutterOpenWhatsapp.sendSingleMessage(app.phone2, '');
                      },
                      child: Image.asset(
                        'assets/images/icon_whatsapp.png',
                        width: 40,
                      ),
                    ),
                    Text(
                      'WhatsApp',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        _openTelegram(app.telegram);
                      },
                      child: Image.asset(
                        'assets/images/icon_telegram.png',
                        width: 40,
                      ),
                    ),
                    Text(
                      'Telegram',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
