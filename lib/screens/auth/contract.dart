import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../screens/account/user/settings.dart';
import '../../screens/account/dashboard.dart';
import '../../services/user.dart';
import '../../widgets/common/custom_alert.dart';
import '../../config/configuration.dart';
import '../../styles/styles.dart';
import '../../widgets/common/custom_list_vertical.dart';
import '../../widgets/common/custom_flat_button_rounded.dart';
import '../../models/user.dart';

class UserContractScreen extends StatefulWidget {
  final UserModel user;
  UserContractScreen({this.user});

  @override
  _UserContractScreenState createState() => _UserContractScreenState();
}

class _UserContractScreenState extends State<UserContractScreen> {
  bool isLoading = false;

  void _submit() async {
    setState(() {
      isLoading = true;
    });
    var result = await AuthService().acceptConditions(
      option: true,
      userKey: widget.user.key,
    );

    CustomAlert()
        .loading(context: context, dismiss: false, isLoading: isLoading);
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
    if (result != null && result.error == null) {
      if (result.conditionsAccepted == true) {
        CustomAlert(
          colorBg: Colors.white,
          colorText: Colors.black,
        ).alert(
          context,
          'Akwaba!',
          'Nous vous souhaitons la bienvenue dans le programme $appName',
          false,
        );

        await Future.delayed(const Duration(seconds: 5));
        Navigator.of(context).pop();

        Navigator.of(context).pushReplacement(
          CubePageRoute(
            enterPage: result.categories.length >= 3
                ? DashboardScreen(userObj: result)
                : UserSettingsScreen(
                    user: result,
                  ),
            exitPage: result.categories.length >= 3
                ? DashboardScreen(userObj: result)
                : UserSettingsScreen(
                    user: result,
                  ),
            duration: const Duration(milliseconds: 300),
          ),
        );
      } else {}
    } else {
      // error
    }
    // print(widget.user.expiry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contrat d\'adhésion',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().bgColor,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            children: [
              Container(
                child: Image.asset(
                  'assets/images/icon-contract.png',
                  //fit: BoxFit.cover,
                ),
                //decoration: BoxDecoration(color: Colors.green),
                height: 70,
                //width: double.infinity,
              ),
              SizedBox(height: 10),
              Container(
                child: Text(
                  'Acceptation des conditions Générales d\'Utilisation (CGU)',
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: MyFontFamily().family1,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Le fait de cliquer sur le bouton vert < J\'ACCEPTE >, implique de facto votre entière adhésion aux conditions générales d\'utilisation du programme $appName et ce, en toute connaissance de cause!',
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              CustomListVertical(
                label: '1- PRÉAMBULE',
                value:
                    '$appName est un programme obtenu de la combinaison du Crowdfunding et du Marketing Digital permettant d\'une part aux entreprises de communiquer plus efficacement avec des cibles bien segmentées, et de récompenser financièrement et matériellement les participants d\'autres parts',
              ),
              CustomListVertical(
                label: '2- OBJET',
                value:
                    'L\'objet des présentes CGU est de définir les conditions dans lesquelles le membre adhère, évolue et bénéficie du programme $appName',
              ),
              CustomListVertical(
                label: '3- OBLIGATIONS',
                value:
                    'Pour bénéficier pleinement du programme $appName, le membre doit dans un premier temps acheter un code de validation avec lequel il crée son compte, puis parrainer un minimum de 2 personnes pour commencer par effectuer des retraits de gains',
              ),
              CustomListVertical(
                label: '4- AUTOSHIP',
                value:
                    'Pour maintenir le programme et le réseau actifs, chaque membre doit activer son autoship tous les 30 jours, soit en achetant un code d\'activation, soit avec ses gains (s\'il en dispose)',
              ),
              CustomListVertical(
                label: '5- GAINS',
                value:
                    'Après avoir inscrit son deuxième filleul, le membre actif recevra des gains de 3 500 FCFA à l\'infini en profondeur au fur et à mesure que son équipe se développe ou se renouvelle avec le paiement des autoships des membres existants',
              ),
              CustomListVertical(
                label: '6- AWARDS',
                value:
                    '''Chaque membre recevra une fois 3 types d'Awards dès qu\'il cumule un certain nombre de membres dans son équipe:

✅ 50 : Android (100 000 F max)
✅ 350 : Moto (700 000 F max)
✅ 2 500 : Voiture (5 Millions F max)''',
              ),
              CustomListVertical(
                label: '7- RESPONSABILITÉS',
                value:
                    '''Le membre est seul responsable de l'utilisation de son compte. Toute connexion avec son nom d'utilisateur et mot de passe, ou transmission de données effectuée en utilisant son compte $appName sera réputée avoir été effectuée par le membre lui-même et sous sa responsabilité exclusive. Il s'engage donc à notifier à $appName toute utilisation non autorisée de son compte dès qu'il en a connaissance.

En cas de non-respect par un membre des présentes CGU, $appName se réserve le droit de lui suspendre son accès.''',
              ),
              CustomListVertical(
                label: '8- DONNÉES PERSONNELLES',
                value:
                    '''Le membre bénéficie d'un droit d'accès, de rectification et d'opposition à la cession de ses données personnelles qu'il peut exercer en adressant un message à l'adresse électronique suivante : novacash[at]novalead.dev''',
              ),
              CustomListVertical(
                label: '9- NOTIFICATIONS',
                value:
                    '''Après son inscription, le membre doit définir 3 catégories dans son profil dans lesquelles il accepte librement recevoir des notifications (mails et/ou SMS) de la part des entreprises partenaires du programme $appName''',
              ),
              CustomListVertical(
                label: '10- RETRAIT DES GAINS',
                value:
                    '''Le membre actif peut effectuer gratuitement le retrait de ses gains à tout moment par l'un des moyens fournis dans l'application: Mobile Money (Orange, Moov, Tmoney), Bitcoin, Ethereum, Ria, MoneyGram et Western Union avec un minimum requis: 
  ✅ Mobile Money: 3 500 F
  ✅ Crypto: 10 000 F
  ✅ Autres: 10 000 F''',
              ),
              CustomListVertical(
                label: '11- MODIFICATIONS',
                value:
                    '''Les CGU prennent effet à compter de leur publication sur la Plateforme $appName et restent en vigueur jusqu'à leur modification partielle ou totale.

Le Membre devra donc se référer à la dernière version des CGU accessible à partir de son compte. $appName se réserve également le droit de modifier ou de faire évoluer à tout moment les conditions du programme. Ces modifications entreront en vigueur dès leur publication.

Tout accès au backoffice après modification des CGU vaut acceptation pure et simple par le membre des nouvelles CGU.''',
              ),
              CustomListVertical(
                label: '12- LOI APPLICABLE',
                value:
                    'Les CGU sont soumises pour leur validité, leur interprétation et leur exécution au droit burkinabé',
              ),
              CustomListVertical(
                label: '13- MENTIONS LÉGALES',
                value: '''(a) Editeur : NovaLead
(b) Mise à jour des CGU : 20/02/2021
(c) Contact : novacash@novalead.dev''',
              ),
              CustomFlatButtonRounded(
                label: 'J\'ACCEPTE',
                borderRadius: 50,
                function: () {
                  _submit();
                },
                bgColor: MyColors().success,
                textColor: Colors.white,
              ),
              SizedBox(height: 11),
            ],
          ),
        ),
      ),
    );
  }
}
