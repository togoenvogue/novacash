import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../../config/configuration.dart';
import '../../../widgets/common/custom_flat_button_rounded.dart';
import '../../../styles/styles.dart';
import '../../../widgets/common/paragraphe.dart';
import '../../play/horse/game.dart';

class GameTypeParisur extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PARI-SUR'),
        backgroundColor: MyColors().primary,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                    child: Image.asset(
                      'assets/images/game_parisur.png',
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  /*Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 20,
                      color: Colors.green[900].withOpacity(0.7),
                      padding: EdgeInsets.only(
                        top: 8,
                        left: 30,
                        right: 20,
                        bottom: 12,
                      ),
                      child: Text(
                        GetGame().game1.description,
                        style: TextStyle(
                          fontSize: 21,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontFamily: MyFontFamily().family2,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                  */
                ],
              ),
              CustomFlatButtonRounded(
                label: '+ Voir la liste des courses (PMU)',
                borderRadius: 50,
                function: () {
                  Navigator.of(context).push(
                    CubePageRoute(
                      enterPage: GameHorseScreen(),
                      exitPage: GameHorseScreen(),
                      duration: const Duration(milliseconds: 300),
                    ),
                  );
                },
                bgColor: MyColors().primary,
                textColor: Colors.white,
                //borderColor: MyColors().success.withOpacity(0.6),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  width: double.infinity,
                  child: Text(
                    'C\'est quoi PARISÛR?',
                    style: TextStyle(
                      fontSize: 22,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    Paragraph(
                      text:
                          'PARISÛR est une opportunité que vous offre $appName pour vous faire rembourser l\'intégralité de votre pari dans 2 cas précis :',
                    ),
                    Paragraph(
                        text:
                            '1 - Lorsque le cheval sur lequel vous avez misé est NON PARTANT à la dernière minute, vous êtes intégralement remboursé'),
                    Paragraph(
                        text:
                            '2 - Lorsque votre cheval ne gagne pas mais occupe la DERNIÈRE PLACE à la fin de la course, vous êtes intégralement remboursé'),
                    Paragraph(
                      text:
                          'Avec PARISÛR, soit vous gagnez, soit vous êtes remboursé avec un peu de chance.',
                    ),
                    Paragraph(
                      text:
                          '$appName vous aide à minimiser les risques et maximiser vos chances de gains!',
                    ),
                    Paragraph(
                      text:
                          'Activez donc PARISÛR à chaque fois que vous placez un pari PMU sur $appName',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
