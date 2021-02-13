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
          'Vous avez besoin d\'aide?',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().primary,
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
              height: 120,
              //width: double.infinity,
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomListVertical(
                label: '1 - Contactez votre parrain',
                value:
                    'Si vous avez une question ou un souci, nous vous conseillons de contacter d\'abord votre parrain (celui dont vous avez utilisé le code d\'invitaiton pour vous inscrire) qui est sensé mieux maitriser l\'application et pourra vous venir en aide plus rapidement',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomListVertical(
                label: '2 - Contactez votre pronostiqueur',
                value:
                    'Si vous avez souscrit à un abonnement auprès d\'un pronostiqueur et que vous avez une requête relative aux pronostics, alors vous devez contacter directement le pronostiqueur en question (dont les contacts sont dans l\'application)',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomListVertical(
                label: '3 - Contactez $appName',
                value:
                    '''Pour vos besoins d\'information générale ou d\'assistance technique, problèmes de dépôt ou de retrait, contactez-nous par : 

Email: ${app.email}
WhatsApp: ${app.phone1}''',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'NB: Pour recevoir une réponse de notre part, vous devez communiquez en FRANCAIS ou en ANGLAIS!',
                style: TextStyle(
                  color: Colors.redAccent,
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
