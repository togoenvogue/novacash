import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../screens/account/dashboard.dart';
import '../../services/user.dart';
import '../../widgets/common/custom_alert.dart';
import '../../config/configuration.dart';
import '../../helpers/common.dart';
import '../../widgets/common/custom_card.dart';
import '../../styles/styles.dart';
import '../../widgets/common/custom_list_vertical.dart';
import '../../screens/public/static/conditions.dart';
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
          'Bienvenue!',
          'Votre contrat a été signé avec succès. Mettez à profit votre période d\'essai de 7 jours!',
          false,
        );

        await Future.delayed(const Duration(seconds: 5));
        Navigator.of(context).pop();

        Navigator.of(context).pushReplacement(
          CubePageRoute(
            enterPage: DashboardScreen(userObj: result),
            exitPage: DashboardScreen(userObj: result),
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
          'A lire attentivement!',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().primary,
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
                height: 120,
                //width: double.infinity,
              ),
              Container(
                child: Text(
                  'Acceptation des conditions générales et signature du contrat d\'adhésion',
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: MyFontFamily().family1,
                    color: MyColors().danger,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10),
              Text(
                  'Ci après l\'essentiel des conditions générales d\'utilisation de l\'application $appName. Vous devez lire et comprendre chaque point avant de continuer'),
              SizedBox(height: 10),
              Text(
                  'Le fait de cliquer sur le bouton vert < J\'ACCEPTE >, implique de facto votre entière adhésion aux conditions générales d\'utilisation de $appName et ce, en toute connaissance de cause!'),
              SizedBox(height: 20),
              CustomListVertical(
                label: '18 ANS ET PLUS',
                value:
                    'Vous ne pouvez pas utiliser $appName si vous êtes un mineur. Si vous validez les conditions, cela suppose que vous déclarez et pouvez éventuellement apporter la preuve que êtes âgé(e) de 18 ans ou plus. Si tel n\'est pas le cas, vous devez fermer immédiatement l\'application, et votre compte sera automatiquement supprimé au bout de 18 jours.',
              ),
              CustomListVertical(
                label: 'LA PÉRIODE D\'ESSAI (7 JOURS)',
                value:
                    'Jusqu\'au ${DateHelper().formatTimeStampFull(widget.user.expiry)}, vous avez un accès sans limite à toutes les fonctionnalités et tester tous modules de l\'application $appName, entre autres les programmes et arrivées des courses PMU, le calendrier des matchs de Football, etc... Vous pouvez aussi faire des dépôts et parier sur toutes les courses PMU et tous les matchs de football, jouer au Jackpot 7jours/7, 24heures/24',
              ),
              CustomListVertical(
                label: 'LE RETRAIT DES GAINS',
                value:
                    'Pour lancer le retrait de vos gains, vous devez être un utilisateur actif. En d\'autres termes, vous ne pouvez pas lancer les retraits tant que vous n\'avez pas activé votre abonnement ou si celui-ci a expiré.',
              ),
              CustomListVertical(
                label: 'L\'ABONNEMENT',
                value:
                    'Pendant ou après votre période d\'essai de 7 jours (${DateHelper().formatTimeStampFull(widget.user.expiry)}), vous devez activer l\'abonnement premium (5000 F par trimestre) pour continuer à accéder à toutes les fonctionnalités de l\'application.',
              ),
              CustomCard(
                color: MyColors().danger,
                content: Column(
                  children: [
                    Text(
                      'Nous vous recommandons vivement de prendre le temps de lire et comprendre les conditions de $appName avant de revenir cliquer sur < J\'ACCEPTE >',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 6),
                    CustomFlatButtonRounded(
                      label: 'Lire les termes et conditions!',
                      borderRadius: 50,
                      function: () {
                        Navigator.of(context).push(
                          CubePageRoute(
                            enterPage: ConditionsScreen(),
                            exitPage: ConditionsScreen(),
                            duration: const Duration(milliseconds: 300),
                          ),
                        );
                      },
                      bgColor: MyColors().white,
                      textColor: Colors.redAccent,
                    ),
                  ],
                ),
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
