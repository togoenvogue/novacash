import 'package:flutter/material.dart';
import 'package:custom_radio_grouped_button/CustomButtons/ButtonTextStyle.dart';
import 'package:custom_radio_grouped_button/CustomButtons/CustomRadioButton.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../../screens/admin/tokens/tokens.dart';
import '../../../services/token.dart';
import '../../../helpers/common.dart';
import '../../../models/user.dart';
import '../../../screens/auth/login.dart';
import '../../../services/user.dart';
import '../../../widgets/common/custom_alert.dart';
import '../../../widgets/common/custom_card.dart';
import '../../../widgets/common/custom_flat_button_rounded.dart';
import '../../../widgets/common/custom_horizontal_diver.dart';
import '../../../widgets/common/custom_list_space_between.dart';
import '../../../styles/styles.dart';

class TokenCreateScreen extends StatefulWidget {
  @override
  _TokenCreateScreenState createState() => _TokenCreateScreenState();
}

class _TokenCreateScreenState extends State<TokenCreateScreen> {
  UserModel thisUser;
  bool isLoading;
  dynamic _amount = 7000;
  int _quantity = 1;

  void _getUser() async {
    var uzr = await AuthService().getThisUser();
    if (uzr.error == null) {
      setState(() {
        thisUser = uzr;
      });
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
      Navigator.of(context).push(
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

  void _submit() async {
    CustomAlert().loading(context: context, dismiss: false, isLoading: true);
    var result = await TokenService().tokenCreate(
      adminKey: thisUser.key,
      quantity: _quantity,
    );
    Navigator.of(context).pop(); // wave off the loading spinner
    if (result != null && result.error == null) {
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Succès!',
        'Vous venez de générer $_quantity codes d\'une valeur de $_amount FCFA!',
        false,
      );
      await Future.delayed(const Duration(seconds: 4));
      Navigator.of(context).pop(); // wave off the confirmation alert
      // redirect
      Navigator.of(context).pushReplacement(
        CubePageRoute(
          enterPage: TokensScreen(),
          exitPage: TokensScreen(),
          duration: const Duration(milliseconds: 300),
        ),
      );
    } else {
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Oops!',
        result.error,
        true,
      );
    }
  }

  void _submitConfirm() async {
    if (thisUser.isSupport
        ? _amount <= thisUser.credits_balance
        : _amount <= thisUser.ewallet_balance) {
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).confirm(
        cancelFn: () {},
        cancelText: 'Non',
        confirmFn: _submit,
        content: Text(
          'Les $_quantity codes vous coûteront $_amount FCFA. Voulez-vous vraiment les générer ?',
          textAlign: TextAlign.center,
        ),
        context: context,
        submitText: 'Oui',
        title: 'Confirmez!',
      );
    } else {
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Attention!',
        'Vous ne disposez pas de fonds nécessaires pour générer $_quantity codes',
        true,
      );
    }
  }

  void _selectedAmount(int quantity) {
    setState(() {
      _quantity = quantity;
      _amount = _quantity * 7000;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Générer un code',
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
                'assets/images/icon-shield.png',
                //fit: BoxFit.cover,
              ),
              //decoration: BoxDecoration(color: Colors.green),
              height: 70,
              //width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Sélectionnez le nombre de codes à générer',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomCard(
                content: thisUser != null
                    ? Column(
                        children: [
                          CustomRadioButton(
                            buttonValues: ['1', '2', '5', '10'],
                            buttonLables: ['1', '2', '5', '10'],
                            defaultSelected: '1',
                            radioButtonValue: (value) {
                              _selectedAmount(int.parse(value));
                            },
                            unSelectedColor:
                                MyColors().bgColor.withOpacity(0.2),
                            selectedColor: MyColors().bgColor.withOpacity(0.8),
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
                            width: 50,
                            elevation: 0,
                          ),
                          CustomListSpaceBetwen(
                            label: 'Nombre de codes',
                            value: '${NumberHelper().formatNumber(_quantity)}',
                          ),
                          CustomHorizontalDiver(),
                          CustomListSpaceBetwen(
                            label: 'Montant à débiter',
                            value:
                                '${NumberHelper().formatNumber(_amount)} FCFA',
                          ),
                          CustomHorizontalDiver(),
                          CustomListSpaceBetwen(
                            label: 'Solde avant',
                            value:
                                '${thisUser.isSupport ? NumberHelper().formatNumber(thisUser.credits_balance) : NumberHelper().formatNumber(thisUser.ewallet_balance)} FCFA',
                          ),
                          CustomHorizontalDiver(),
                          CustomListSpaceBetwen(
                            label: 'Solde après',
                            value:
                                '${thisUser.isSupport ? NumberHelper().formatNumber(thisUser.credits_balance - _amount) : NumberHelper().formatNumber(thisUser.ewallet_balance - _amount)} FCFA',
                          ),
                        ],
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: CustomFlatButtonRounded(
                label: 'Générer',
                borderRadius: 50,
                function: _submitConfirm,
                borderColor: Colors.transparent,
                bgColor: Colors.green.withOpacity(0.6),
                textColor: Colors.white,
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
