import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';
import 'package:custom_radio_grouped_button/CustomButtons/ButtonTextStyle.dart';
import 'package:custom_radio_grouped_button/CustomButtons/CustomRadioButton.dart';

import '../../../helpers/common.dart';
import '../../../models/user.dart';
import '../../../screens/auth/login.dart';
import '../../../services/user.dart';
import '../../../widgets/common/custom_alert.dart';
import '../../../widgets/common/custom_card.dart';
import '../../../widgets/common/custom_horizontal_diver.dart';
import '../../../widgets/common/custom_list_space_between.dart';
import '../../../styles/styles.dart';

class AwardsScreen extends StatefulWidget {
  @override
  _AwardsScreenState createState() => _AwardsScreenState();
}

class _AwardsScreenState extends State<AwardsScreen> {
  bool isLoading = false;
  String url = 'assets/images/award3.jpg';
  dynamic valeur = 0;
  dynamic condition = 0;
  dynamic effort = 0;
  dynamic balance = 0;
  String description = 'Cliquez sur un grade pour voir les détails';
  bool showAward = false;
  UserModel thisUser;
  bool isQualified;

  final String image1 = 'https://mastercash.network/_novacash/award1.jpg';
  final String image2 = 'https://mastercash.network/_novacash/award2.jpg';
  final String image3 = 'https://mastercash.network/_novacash/award3.jpg';

  void _selectedType(String type) {
    setState(() {
      showAward = true;
      if (type == 'SILVER') {
        description =
            'Avec seulement 50 personnes dans votre équipe, vous recevez un téléphone Android d\'une valeur maximale de 100 000 FCFA';
        condition = 50;
        balance = thisUser.teamCount - 50;
        valeur = 100000;
        effort = thisUser.teamCount;
        url = image1;
        isQualified = thisUser.gadget1Qualified;
        //print(thisUser.gadget1Qualified);
      } else if (type == 'GOLD') {
        description =
            'Avec 350 personnes dans votre équipe, vous vous qualifiez pour une moto d\'une valeur maximale de 700 000 FCFA';
        condition = 350;
        balance = thisUser.teamCount - 350;
        valeur = 700000;
        effort = thisUser.teamCount;
        url = image2;
        isQualified = thisUser.gadget2Qualified;
        //print(thisUser.gadget1Qualified);
      } else {
        description =
            'Recevez la voiture de votre choix d\'une valeur maximale de 5 millions avec seulement de 2 500 personnes dans votre équipe';
        condition = 1500;
        balance = thisUser.teamCount - 1500;
        valeur = 5000000;
        effort = thisUser.teamCount;
        url = image3;
        isQualified = thisUser.gadget3Qualified;
        //print(thisUser.gadget1Qualified);
      }
    });
  }

  void _getUser() async {
    var uzr = await AuthService().getThisUser();
    if (uzr.error == null) {
      setState(() {
        thisUser = uzr;
      });
      _selectedType('SILVER');
    } else if (uzr.error == 'AUTH_EXPIRED') {
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Accès refusé',
        'Vous essayez d\'accéder à un espace sécurisé. Connectez-vous et essayez de nouveau',
        false,
      );
      await Future.delayed(const Duration(seconds: 5));
      // redirect to login
      Navigator.of(context).pushReplacement(
        CubePageRoute(
          enterPage: LoginScreen(),
          exitPage: LoginScreen(),
          duration: const Duration(milliseconds: 300),
        ),
      );
    } else {
      // show error
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Oops!',
        uzr.error,
        true,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Awards',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().bgColor,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Column(
            children: [
              Text(
                description,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),
              CustomRadioButton(
                buttonLables: ['SILVER', 'GOLD', 'RUBY'],
                buttonValues: ['SILVER', 'GOLD', 'RUBY'],
                defaultSelected: 'SILVER',
                radioButtonValue: (value) {
                  _selectedType(value);
                },
                unSelectedColor: Colors.white.withOpacity(0.6),
                selectedColor: Colors.green.withOpacity(0.8),
                selectedBorderColor: Colors.transparent,
                unSelectedBorderColor: Colors.transparent,
                enableShape: true,
                enableButtonWrap: true,
                buttonTextStyle: ButtonTextStyle(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: MyFontFamily().family2,
                  ),
                ),
                width: 90,
                elevation: 0,
              ),
              SizedBox(height: 10),
              if (showAward)
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                  child: FadeInImage(
                    placeholder: AssetImage('assets/images/placeholder.png'),
                    image: NetworkImage(url) == null
                        ? Image.asset('assets/images/placeholder.png')
                        : NetworkImage(url),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 230,
                  ),
                ),
              if (showAward)
                CustomCard(
                  content: isLoading == false
                      ? Column(
                          children: [
                            CustomListSpaceBetwen(
                              label: 'Valeur',
                              value:
                                  '${NumberHelper().formatNumber(valeur)} FCFA',
                            ),
                            CustomHorizontalDiver(),
                            CustomListSpaceBetwen(
                              label: 'Condition',
                              value:
                                  '${NumberHelper().formatNumber(condition)} membres',
                            ),
                            if (isQualified == false) CustomHorizontalDiver(),
                            if (isQualified == false)
                              CustomListSpaceBetwen(
                                label: 'Progression',
                                value:
                                    '${NumberHelper().formatNumber(effort)}/${NumberHelper().formatNumber(condition)} (-${NumberHelper().formatNumber(condition - effort)})',
                              ),
                            SizedBox(height: 5),
                            if (isQualified == true)
                              Icon(
                                Icons.check_circle,
                                size: 44,
                                color: Colors.green,
                              ),
                          ],
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
