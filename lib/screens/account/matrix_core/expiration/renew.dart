import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';

import 'renew_crypto.dart';
import '../../../../screens/auth/login.dart';
import '../../../../screens/public/apn/apn.dart';
import '../../../../widgets/common/custom_text_input.dart';
import '../../../../helpers/common.dart';
import '../../../../models/user.dart';
import '../../../../screens/account/dashboard.dart';
import '../../../../services/expiration.dart';
import '../../../../services/user.dart';
import '../../../../styles/styles.dart';
import '../../../../widgets/common/custom_alert.dart';
import '../../../../widgets/common/custom_card.dart';
import '../../../../widgets/common/custom_flat_button_rounded.dart';
import '../../../../widgets/common/custom_horizontal_diver.dart';
import '../../../../widgets/common/custom_list_space_between.dart';

class ExpirRenewScreen extends StatefulWidget {
  @override
  _ExpirRenewScreenState createState() => _ExpirRenewScreenState();
}

UserModel thisUser;
bool isLoading;
final dynamic _totalCost = 7000;
var _nextExpir;
String _code;

class _ExpirRenewScreenState extends State<ExpirRenewScreen> {
  void _renewWithCode() async {
    if (_code != null && _code.length >= 16) {
      CustomAlert().loading(context: context, dismiss: false, isLoading: true);
      var result = await ExpirationService()
          .renewWithCode(userKey: thisUser.key, code: _code);
      Navigator.of(context).pop(); // wave off the loading
      if (result.error == null) {
        // recall the user
        var r = await AuthService().getThisUser();
        if (r.error == null) {
          CustomAlert(
            colorBg: Colors.white,
            colorText: Colors.black,
          ).alert(
            context,
            'Félicitations!',
            'Votre compte a été renouvelé avec succès pour une durée de 30 jours',
            false,
          );
          // delay
          await Future.delayed(const Duration(seconds: 5));
          Navigator.of(context).pop(); // wave off the confirmation alert
          // redirect
          Navigator.of(context).pushReplacement(
            CubePageRoute(
              enterPage: DashboardScreen(userObj: r),
              exitPage: DashboardScreen(userObj: r),
              duration: const Duration(milliseconds: 300),
            ),
          );
        } else {
          CustomAlert(
            colorBg: Colors.white,
            colorText: Colors.black,
          ).alert(
            context,
            'Oops',
            result.error,
            true,
          );
        }
      } else {
        CustomAlert(
          colorBg: Colors.white,
          colorText: Colors.black,
        ).alert(
          context,
          'Oops',
          result.error,
          true,
        );
      }
    } else {
      // not enough balance
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Attention',
        'Veuillez entrer un code de validation valide',
        true,
      );
    }
  }

  // redirect to reload
  void _redirectToReload() {
    Navigator.of(context).pushReplacement(
      CubePageRoute(
        enterPage: ApnScreen(),
        exitPage: ApnScreen(),
        duration: const Duration(milliseconds: 300),
      ),
    );
  }

  // redirect to dashboard
  void _backToHome() {
    Navigator.of(context).pushReplacement(
      CubePageRoute(
        enterPage: DashboardScreen(userObj: thisUser),
        exitPage: DashboardScreen(userObj: thisUser),
        duration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _payWithCrypto() {
    Navigator.of(context).pushReplacement(
      CubePageRoute(
        enterPage: AutoshipChoice(),
        exitPage: AutoshipChoice(),
        duration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _renewWithEwallet() async {
    if (thisUser.ewallet_balance >= _totalCost) {
      CustomAlert().loading(context: context, dismiss: false, isLoading: true);
      var result =
          await ExpirationService().renewWithEwallet(userKey: thisUser.key);
      Navigator.of(context).pop(); // wave off the loading
      if (result.error == null) {
        // recall the user
        var r = await AuthService().getThisUser();
        if (r.error == null) {
          CustomAlert(
            colorBg: Colors.white,
            colorText: Colors.black,
          ).alert(
            context,
            'Félicitations!',
            'Votre compte a été renouvelé avec succès pour une durée de 30 jours',
            false,
          );
          // delay
          await Future.delayed(const Duration(seconds: 5));
          Navigator.of(context).pop(); // wave off the confirmation alert
          // redirect
          Navigator.of(context).pushReplacement(
            CubePageRoute(
              enterPage: DashboardScreen(userObj: r),
              exitPage: DashboardScreen(userObj: r),
              duration: const Duration(milliseconds: 300),
            ),
          );
        } else {
          CustomAlert(
            colorBg: Colors.white,
            colorText: Colors.black,
          ).alert(
            context,
            'Oops',
            result.error,
            true,
          );
        }
      } else {
        CustomAlert(
          colorBg: Colors.white,
          colorText: Colors.black,
        ).alert(
          context,
          'Oops',
          result.error,
          true,
        );
      }
    } else {
      // not enough balance
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).confirm(
        cancelFn: _backToHome,
        cancelText: 'Non',
        confirmFn: _redirectToReload,
        content: Text(
          'Vous ne disposez pas de gains nécessaires pour renouveler votre compte. Voulez-vous acheter un code de validation?',
          textAlign: TextAlign.center,
        ),
        context: context,
        submitText: 'Oui',
        title: 'Gains insuffisants',
      );
    }
  }

  void _ewalletConfirm() {
    CustomAlert(
      colorBg: Colors.white,
      colorText: Colors.black,
    ).confirm(
      cancelFn: () {},
      cancelText: 'Non',
      confirmFn: _renewWithEwallet,
      content: Text(
        'Voulez-vous vraiment payer votre autoship avec vos gains?',
        textAlign: TextAlign.center,
      ),
      context: context,
      submitText: 'Oui',
      title: 'Confirmez',
    );
  }

  void _getUser() async {
    var uzr = await AuthService().getThisUser();
    setState(() {
      isLoading = false;
    });
    if (uzr != null && uzr.error == null) {
      setState(() {
        thisUser = uzr;
        _nextExpir = uzr.expiry > 0
            ? 90 * 86400000 + uzr.expiry
            : 90 * 86400000 + DateTime.now().millisecondsSinceEpoch;
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
        child: Column(
          children: [
            Container(
              child: Image.asset(
                'assets/images/icon-autoship.png',
                //fit: BoxFit.cover,
              ),
              //decoration: BoxDecoration(color: Colors.green),
              height: 50,
              //width: double.infinity,
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Le renouvellement de votre autoship maintient votre compte actif',
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
                          CustomListSpaceBetwen(
                            label: 'Montant à payer',
                            value:
                                '${NumberHelper().formatNumber(_totalCost)} FCFA',
                          ),
                          CustomHorizontalDiver(),
                          CustomListSpaceBetwen(
                            label: 'Validité',
                            value: '30 jours',
                          ),
                          CustomHorizontalDiver(),
                          CustomListSpaceBetwen(
                            label: 'Expiration',
                            value:
                                '${DateHelper().formatTimeStamp(_nextExpir)}',
                          ),
                          CustomListSpaceBetwen(
                            label: 'Votre solde',
                            value:
                                '${NumberHelper().formatNumber(thisUser.ewallet_balance)} FCFA',
                          ),
                          CustomTextInput(
                            isObscure: false,
                            maxLength: 16,
                            maxLines: 1,
                            inputType: TextInputType.number,
                            labelText: 'Entrez un code de validation',
                            helpText: 'Ex: 16135-90376-9X5W',
                            onChanged: (value) {
                              setState(() {
                                _code = value;
                              });
                            },
                          ),
                          CustomFlatButtonRounded(
                            label: 'Valider avec le code',
                            borderRadius: 50,
                            function: _renewWithCode,
                            borderColor: Colors.transparent,
                            bgColor: MyColors().bgColor,
                            textColor: Colors.white,
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
                label: 'Payer avec mes gains',
                borderRadius: 50,
                function: _ewalletConfirm,
                borderColor: Colors.transparent,
                bgColor: MyColors().primary2,
                textColor: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: CustomFlatButtonRounded(
                label: 'Acheter un Token (Code)',
                borderRadius: 50,
                function: () {
                  Navigator.of(context).pushReplacement(
                    CubePageRoute(
                      enterPage: ApnScreen(),
                      exitPage: ApnScreen(),
                      duration: const Duration(milliseconds: 300),
                    ),
                  );
                },
                borderColor: Colors.transparent,
                bgColor: Colors.yellow,
                textColor: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: CustomFlatButtonRounded(
                label: 'Payer avec BTC ou ETH',
                borderRadius: 50,
                function: _payWithCrypto,
                borderColor: Colors.transparent,
                bgColor: MyColors().info,
                textColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
