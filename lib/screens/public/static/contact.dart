import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';

import '../../../models/config.dart';
import '../../../config/configuration.dart';
import '../../../styles/styles.dart';
import '../../../widgets/common/custom_list_vertical.dart';

class ContactScreen extends StatelessWidget {
  final AppConfigModel app;
  ContactScreen({this.app});

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'NB: Pour recevoir une réponse de notre part, vous devez communiquez en FRANCAIS ou en ANGLAIS!',
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    FlutterOpenWhatsapp.sendSingleMessage(app.phone2, '');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Image.asset(
                      'assets/images/icon_whatsapp.png',
                      width: 40,
                    ),
                  ),
                ),
                SizedBox(width: 0),
              ],
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
