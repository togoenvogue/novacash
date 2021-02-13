import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';

import '../../models/apn.dart';

class ApnListItem extends StatelessWidget {
  final ApnModel apn;

  ApnListItem({this.apn});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.black.withOpacity(0.1)),
          //top: BorderSide(width: 0, color: MyColors().normal),
        ),
      ),
      child: Row(
        children: [
          /*
          Container(
            height: 60,
            width: 60,
            margin: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 5,
            ),
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
            decoration: BoxDecoration(
              color: Colors.white,
              //borderRadius: BorderRadius.circular(100),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black,
              ),
            ),
          ),
          */
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
            child: Image.network(
              apn.picture,
              width: 65,
              height: 65,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 7),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                apn.fullName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 3),
              Text('+${apn.username}'),
              SizedBox(height: 3),
              Text(apn.email),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    FlutterOpenWhatsapp.sendSingleMessage(apn.whatsApp,
                        'Bonjour, pouvez-vous m\'envoyer votre code d\'invitation pour me permettre de m\'inscrire sur l\'application mobile betNino? Merci!');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Image.asset(
                      'assets/images/icon_whatsapp.png',
                      width: 35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
