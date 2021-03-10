import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';
import 'package:custom_radio_grouped_button/CustomButtons/ButtonTextStyle.dart';
import 'package:custom_radio_grouped_button/CustomButtons/CustomRadioButton.dart';

import '../../screens/auth/signup_p2p_choice.dart';
import '../../screens/auth/signup_premium_choice.dart';
import '../../widgets/common/custom_horizontal_diver.dart';
import '../../widgets/common/custom_list_space_between.dart';
import '../../widgets/common/custom_card.dart';
import '../../widgets/common/custom_flat_button_rounded.dart';
import '../../styles/styles.dart';

class SignupChoice extends StatefulWidget {
  @override
  _SignupChoiceState createState() => _SignupChoiceState();
}

class _SignupChoiceState extends State<SignupChoice> {
  String _selectedChannel;
  bool isLoading = false;

  void _channel(String channel) {
    setState(() {
      _selectedChannel = channel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Choix de matrice',
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
              CustomCard(
                color: Colors.white,
                content: Column(
                  children: [
                    Text(
                      'Quelle matrice souhaitez-vous intégrer?',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    CustomRadioButton(
                      buttonValues: ['PREMIUM', 'P2P-SILVER'],
                      buttonLables: ['PREMIUM', 'P2P-SILVER'],
                      radioButtonValue: (value) {
                        _channel(value);
                      },
                      unSelectedColor: Colors.black.withOpacity(0.1),
                      selectedColor: Colors.green.withOpacity(0.8),
                      selectedBorderColor: Colors.transparent,
                      unSelectedBorderColor: Colors.black.withOpacity(0.1),
                      enableShape: true,
                      enableButtonWrap: true,
                      buttonTextStyle: ButtonTextStyle(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: MyFontFamily().family1,
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                      width: 130,
                      elevation: 0,
                    ),
                  ],
                ),
              ),
              if (_selectedChannel != null && _selectedChannel == 'PREMIUM')
                CustomCard(
                  content: Column(
                    children: [
                      CustomListSpaceBetwen(
                        label: 'Matrice',
                        value: '2 x n (infini)',
                      ),
                      CustomHorizontalDiver(),
                      CustomListSpaceBetwen(
                        label: 'Adhésion',
                        value: '7 000 FCFA',
                      ),
                      CustomHorizontalDiver(),
                      CustomListSpaceBetwen(
                        label: 'Autoship',
                        value: '7 000 F/mois',
                      ),
                      CustomHorizontalDiver(),
                      CustomListSpaceBetwen(
                        label: 'Gain',
                        value: '3 500 à l\'inifini',
                      ),
                      CustomListSpaceBetwen(
                        label: 'Paiement',
                        value: 'Par le système',
                      ),
                      CustomHorizontalDiver(),
                      CustomListSpaceBetwen(
                        label: 'Awards',
                        value: 'Android, Moto et Voiture',
                      ),
                      CustomFlatButtonRounded(
                        label: 'Je m\'inscris maintenant',
                        borderRadius: 50,
                        function: () {
                          Navigator.of(context).pushReplacement(
                            CubePageRoute(
                              enterPage: SignupPremiumChoice(),
                              exitPage: SignupPremiumChoice(),
                              duration: const Duration(milliseconds: 300),
                            ),
                          );
                        },
                        borderColor: MyColors().normal,
                        bgColor: MyColors().normal,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              if (_selectedChannel != null && _selectedChannel == 'P2P-SILVER')
                CustomCard(
                  content: Column(
                    children: [
                      CustomListSpaceBetwen(
                        label: 'Matrice',
                        value: '3 x 2',
                      ),
                      CustomHorizontalDiver(),
                      CustomListSpaceBetwen(
                        label: 'Adhésion',
                        value: '5 000 FCFA',
                      ),
                      CustomHorizontalDiver(),
                      CustomListSpaceBetwen(
                        label: 'Autoship',
                        value: 'Pas d\'autoship',
                      ),
                      CustomHorizontalDiver(),
                      CustomListSpaceBetwen(
                        label: 'Gain',
                        value: '35 000 F à l\'inifini',
                      ),
                      CustomListSpaceBetwen(
                        label: 'Paiement',
                        value: 'Membre à membre',
                      ),
                      CustomHorizontalDiver(),
                      CustomListSpaceBetwen(
                        label: 'Awards',
                        value: 'Aucun Award',
                      ),
                      CustomFlatButtonRounded(
                        label: 'Je m\'inscris maintenant',
                        borderRadius: 50,
                        function: () {
                          Navigator.of(context).pushReplacement(
                            CubePageRoute(
                              enterPage: SignupP2PChoice(),
                              exitPage: SignupP2PChoice(),
                              duration: const Duration(milliseconds: 300),
                            ),
                          );
                        },
                        borderColor: MyColors().info,
                        bgColor: MyColors().info,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
