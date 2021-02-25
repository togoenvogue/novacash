import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';
import 'package:custom_radio_grouped_button/CustomButtons/ButtonTextStyle.dart';
import 'package:custom_radio_grouped_button/CustomButtons/CustomRadioButton.dart';

import '../../../models/user.dart';
import '../../../screens/account/expiration/renew_crypto_pay.dart';
import '../../../screens/auth/login.dart';
import '../../../services/reload.dart';
import '../../../services/user.dart';
import '../../../styles/styles.dart';
import '../../../widgets/common/custom_alert.dart';
import '../../../widgets/common/custom_card.dart';
import '../../../widgets/common/custom_flat_button_rounded.dart';

class AutoshipChoice extends StatefulWidget {
  @override
  _AutoshipChoiceState createState() => _AutoshipChoiceState();
}

class _AutoshipChoiceState extends State<AutoshipChoice> {
  UserModel thisUser;
  String _selectedChannel;
  bool isLoading = false;

  void _channel(String channel) {
    setState(() {
      _selectedChannel = channel;
    });
  }

  _verifyPayin() async {
    setState(() {
      isLoading = true;
    });
    CustomAlert().loading(
      context: context,
      dismiss: false,
      isLoading: isLoading,
    );
    var result = await ReloadService().payinPending(
      userKey: thisUser.username,
      currency: _selectedChannel,
      type: 'Autoship',
    );
    setState(() {
      isLoading = false;
    });

    //Navigator.of(context).pop();
    if (result != null && result.error == null) {
      if (result.status == 'Pending') {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
          CubePageRoute(
            enterPage: AutoshipCryptoPay(
              username: thisUser.username,
              userKey: thisUser.key,
              systemAddress: result.systemAddress,
              amountCrypto: result.amountCrypto,
              currency: result.currency,
            ),
            exitPage: AutoshipCryptoPay(
              username: thisUser.username,
              userKey: thisUser.key,
              systemAddress: result.systemAddress,
              amountCrypto: result.amountCrypto,
              currency: result.currency,
            ),
            duration: const Duration(milliseconds: 300),
          ),
        );
        // renew
      } else {
        // execute renewal
      }
    } else if (result != null && result.error == 'NO_PENDING_FOUND') {
      // create new pending
      setState(() {
        isLoading = true;
      });
      var result = await ReloadService().cryptoPayinCreateUsername(
        amount: 7000,
        currency: _selectedChannel,
        username: thisUser.username,
        type: 'Autoship',
      );
      setState(() {
        isLoading = false;
      });
      if (result != null && result.error == null) {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
          CubePageRoute(
            enterPage: AutoshipCryptoPay(
              username: thisUser.username,
              userKey: thisUser.key,
              systemAddress: result.systemAddress,
              amountCrypto: result.amountCrypto,
              currency: result.currency,
            ),
            exitPage: AutoshipCryptoPay(
              username: thisUser.username,
              userKey: thisUser.key,
              systemAddress: result.systemAddress,
              amountCrypto: result.amountCrypto,
              currency: result.currency,
            ),
            duration: const Duration(milliseconds: 300),
          ),
        );
      } else {
        // alert
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
  }

  void _getUser() async {
    var uzr = await AuthService().getThisUser();
    setState(() {
      isLoading = false;
    });
    if (uzr != null && uzr.error == null) {
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
    // TODO: implement initState
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Autoship',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().bgColor,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            children: [
              CustomCard(
                color: Colors.white,
                content: Column(
                  children: [
                    Text(
                      'Par quel moyen souhaitez-vous payer votre autoship de 7 000 FCFA?',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    CustomRadioButton(
                      buttonValues: ['BTC', 'ETH'],
                      buttonLables: ['BTC', 'ETH'],
                      radioButtonValue: (value) {
                        _channel(value);
                      },
                      unSelectedColor: MyColors().primary.withOpacity(0.2),
                      selectedColor: MyColors().success,
                      selectedBorderColor: Colors.transparent,
                      unSelectedBorderColor: Colors.transparent,
                      enableShape: true,
                      enableButtonWrap: true,
                      buttonTextStyle: ButtonTextStyle(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: MyFontFamily().family2,
                          color: Colors.white,
                        ),
                      ),
                      width: 90,
                      elevation: 0,
                    ),
                  ],
                ),
              ),
              if (_selectedChannel != null &&
                  thisUser != null &&
                  thisUser.username.length >= 11)
                CustomFlatButtonRounded(
                  label: 'Valider',
                  borderRadius: 50,
                  function: () {
                    _verifyPayin();
                  },
                  borderColor: Colors.transparent,
                  bgColor: Colors.green.withOpacity(0.6),
                  textColor: Colors.white,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
