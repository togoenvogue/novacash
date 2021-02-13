import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../../helpers/common.dart';
import '../../../models/user.dart';
import '../../../screens/account/dashboard.dart';
import '../../../screens/auth/login.dart';
import '../../../services/reload.dart';
import '../../../services/user.dart';
import '../../../widgets/common/custom_alert.dart';
import '../../../widgets/common/custom_card.dart';
import '../../../widgets/common/custom_horizontal_diver.dart';
import '../../../widgets/common/custom_list_space_between.dart';
import '../../../widgets/common/custom_flat_button_rounded.dart';
import '../../../widgets/common/custom_text_input.dart';
import '../../../styles/styles.dart';

class ReloadEwalletScreen extends StatefulWidget {
  @override
  _ReloadEwalletScreenState createState() => _ReloadEwalletScreenState();
}

class _ReloadEwalletScreenState extends State<ReloadEwalletScreen> {
  dynamic _amount;
  bool isLoading = false;
  //var _errMessage = 'Oops!';
  UserModel _thisUser;
  final dynamic _minimumToTransfer = 100;
  final player = AudioCache();

  void _submit() async {
    if (_amount != null && _amount >= _minimumToTransfer) {
      setState(() {
        isLoading = true;
      });
      CustomAlert()
          .loading(context: context, dismiss: false, isLoading: isLoading);
      var result = await ReloadService()
          .reloadWithEwallet(amount: _amount, userKey: _thisUser.key);
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();

      if (result.error == null) {
        CustomAlert(
          colorBg: Colors.white,
          colorText: Colors.black,
        ).alert(
            context,
            'Succès!',
            '$_amount FCFA ont été crédités avec succès sur votre compte dépôt avec vos gains',
            false);
        // delay, redirect
        await Future.delayed(const Duration(seconds: 5));
        var uzr = await AuthService().getThisUser();
        if (uzr.error == null) {
          setState(() {
            _thisUser = uzr;
          });
          _backHome(uzr);
        } else {
          _backHome(_thisUser);
        }
      } else {
        CustomAlert(
          colorBg: Colors.white,
          colorText: Colors.black,
        ).alert(context, 'Oops!', result.error, true);
      }
    } else {
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
          context,
          'Attention!',
          'Le minimum de gains que vous pouvez transférer est de $_minimumToTransfer FCFA',
          true);
    }
  }

  // backHome
  void _backHome(dynamic user) {
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacement(
      CubePageRoute(
        enterPage: DashboardScreen(userObj: user),
        exitPage: DashboardScreen(userObj: user),
        duration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _getUser() async {
    var uzr = await AuthService().getThisUser();
    if (uzr.error == null) {
      setState(() {
        _thisUser = uzr;
      });
      // do any other stuff here

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
      Navigator.of(context).pop();
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
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dépôt avec vos gains',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().primary,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                'Vous êtes sur le point de faire un dépôt sur votre compte avec le solde de vos gains',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              CustomTextInput(
                labelText:
                    'Entrez le montant (FCFA) à créditer sur votre compte sans esapce',
                isObscure: false,
                maxLines: 1,
                inputType: TextInputType.number,
                maxLength: 7,
                helpText: 'Minimum à créditer: $_minimumToTransfer FCFA',
                onChanged: (amout) {
                  setState(() {
                    _amount = int.parse(amout);
                  });
                },
              ),
              if (_thisUser != null && _amount != null && _amount > 0)
                CustomCard(
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomListSpaceBetwen(
                        label: 'Total des gains',
                        value:
                            '${NumberHelper().formatNumber(_thisUser.ewallet_total)} FCFA',
                      ),
                      CustomHorizontalDiver(),
                      CustomListSpaceBetwen(
                        label: 'Solde des gains',
                        value:
                            '${NumberHelper().formatNumber(_thisUser.ewallet_balance)} FCFA',
                      ),
                      CustomHorizontalDiver(),
                      CustomListSpaceBetwen(
                        label: 'Montant à transférer',
                        value: '${NumberHelper().formatNumber(_amount)} FCFA',
                      ),
                      CustomHorizontalDiver(),
                      CustomListSpaceBetwen(
                        label: 'Solde après',
                        value:
                            '${NumberHelper().formatNumber(_thisUser.ewallet_balance - _amount)} FCFA',
                      ),
                    ],
                  ),
                ),
              if (_thisUser != null && _amount != null && _amount > 0)
                CustomFlatButtonRounded(
                  label: 'Valider le dépôt',
                  borderRadius: 50,
                  function: _submit,
                  bgColor: MyColors().primary,
                  textColor: Colors.white,
                ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
