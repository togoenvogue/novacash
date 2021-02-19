import 'package:flutter/material.dart';

import '../../../config/configuration.dart';
import '../../../helpers/common.dart';
import '../../../models/config.dart';
import '../../../styles/styles.dart';
import '../../../widgets/common/custom_list_vertical.dart';

class AffiliationScreen extends StatelessWidget {
  final AppConfigModel app;
  AffiliationScreen({this.app});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Affiliation : Gains illimités',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().primary,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                child: Image.asset(
                  'assets/images/icon-affiliate.png',
                  //fit: BoxFit.cover,
                ),
                //decoration: BoxDecoration(color: Colors.green),
                height: 120,
                //width: double.infinity,
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  child: Text(
                    'En dehors de vos gains tirés des jeux, $appName vous permet de gagner de l\'argent supplémentaire à travers son programme d\'affiliation sur mesure',
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CustomListVertical(
                  label: '1 - Inscrivez-vous',
                  value: 'ddfdfd',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CustomListVertical(
                  label: '2 - Inscrivez d\'autres utilisateurs',
                  value:
                      'Pour commencer par recevoir les bonus d\'affiliation, vous devez communiquer votre code d\'invitation à vos amis qui voudront s\'inscrire et utiliser $appName',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CustomListVertical(
                  label: 'a) 5 à 15% sur les abonnements',
                  value:
                      '''A chaque fois qu\'un membre de votre équipe souscrit ou renouvelle son abonnement, vous bénéficiez systématiquement d\'une commission allant de 5 à 15%
                      
✅ Niveau 1: 15%
✅ Niveau 2: 5%
✅ Niveau 3: 5%''',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CustomListVertical(
                  label: 'b) 5 à 15% au Jackpot',
                  value:
                      '''A chaque fois qu\'un membre de votre equipe joue et gagne au Jackpot, il récupère son dû, et vous recevez une commission allant de 5 à 15%
                      
✅ Niveau 1: 15%
✅ Niveau 2: 5%
✅ Niveau 3: 5%''',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CustomListVertical(
                  label: 'Paiement instantanné',
                  value:
                      'Toutes les commissions sont payées en temps réel, pas demain, pas dans une heure, mais instantanément.',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CustomListVertical(
                  label: 'Aucune limite',
                  value:
                      'Vous pouvez inscrire autant de personnes que vous pouvez avec votre code d\'invitation et gagner des commissions sans limite aucune',
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
