import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../../helpers/common.dart';
import '../../../models/user.dart';
import '../../../screens/account/dashboard.dart';
import '../../../screens/account/reload/reload_choice.dart';
import '../../../screens/auth/login.dart';
import '../../../services/expiration.dart';
import '../../../services/user.dart';
import '../../../styles/styles.dart';
import '../../../widgets/common/custom_alert.dart';
import '../../../widgets/common/custom_card.dart';
import '../../../widgets/common/custom_flat_button_rounded.dart';
import '../../../widgets/common/custom_horizontal_diver.dart';
import '../../../widgets/common/custom_list_space_between.dart';

class ExpirRenewScreen extends StatefulWidget {
  @override
  _ExpirRenewScreenState createState() => _ExpirRenewScreenState();
}

UserModel thisUser;
bool isLoading;
final _cost = 5000;
var _nextExpir;

class _ExpirRenewScreenState extends State<ExpirRenewScreen> {
  // redirect to reload
  void _redirectToReload() {
    Navigator.of(context).push(
      CubePageRoute(
        enterPage: ReloadChoiceScreen(),
        exitPage: ReloadChoiceScreen(),
        duration: const Duration(milliseconds: 300),
      ),
    );
  }

  // redirect to dashboard
  void _backToHome() {
    Navigator.of(context).push(
      CubePageRoute(
        enterPage: DashboardScreen(userObj: thisUser),
        exitPage: DashboardScreen(userObj: thisUser),
        duration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _submit() async {
    if (thisUser.credits_balance >= _cost) {
      CustomAlert().loading(context: context, dismiss: false, isLoading: true);
      var result = await ExpirationService().renew(userKey: thisUser.key);
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
            'Votre compte a été renouvelé avec succès pour une durée de 90 jours',
            false,
          );
          // delay
          await Future.delayed(const Duration(seconds: 5));
          Navigator.of(context).pop(); // wave off the confirmation alert
          // redirect
          Navigator.of(context).push(
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
            false,
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
          false,
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
          'Vous ne disposez pas de fonds nécessaires pour renouveler votre compte. Voulez-vous effectuer un dépôt maintenant?',
          textAlign: TextAlign.center,
        ),
        context: context,
        submitText: 'Oui',
        title: 'Effectuez un dépôt',
      );
    }
  }

  void _getUser() async {
    var uzr = await AuthService().getThisUser();
    if (uzr.error == null) {
      setState(() {
        thisUser = uzr;
        _nextExpir = uzr.expiry > 0
            ? 90 * 86400000 + uzr.expiry
            : 90 * 86400000 + DateTime.now().millisecondsSinceEpoch;
      });
      // make sure the user has enough money to pay
      if (uzr.credits_balance < _cost) {
        CustomAlert(
          colorBg: Colors.white,
          colorText: Colors.black,
        ).confirm(
          cancelFn: _backToHome,
          cancelText: 'Non',
          confirmFn: _redirectToReload,
          content: Text(
            'Vous ne disposez pas de fonds nécessaires pour renouveler votre compte. Souhaitez-vous effectuer un dépôt?',
            textAlign: TextAlign.center,
          ),
          context: context,
          submitText: 'Oui',
          title: 'Solde insuffisant!',
        );
      }
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
          'Je m\'abonne',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().primary,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Image.asset(
                'assets/images/icon-premium.png',
                //fit: BoxFit.cover,
              ),
              //decoration: BoxDecoration(color: Colors.green),
              height: 120,
              //width: double.infinity,
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Afin d\'avoir accès à tous nos services premium dont le pari dans l\'application et les retraits, vous devez effectuer un dépôt sur votre compte et payer votre abonnement',
                style: TextStyle(fontSize: 16),
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
                            value: '${NumberHelper().formatNumber(_cost)} FCFA',
                          ),
                          CustomHorizontalDiver(),
                          CustomListSpaceBetwen(
                            label: 'Validité',
                            value: '90 jours',
                          ),
                          CustomHorizontalDiver(),
                          CustomListSpaceBetwen(
                            label: 'Expiration',
                            value:
                                '${DateHelper().formatTimeStamp(_nextExpir)}',
                          ),
                          CustomHorizontalDiver(),
                          CustomListSpaceBetwen(
                            label: 'Solde de votre compte',
                            value:
                                '${NumberHelper().formatNumber(thisUser.credits_balance)} FCFA',
                          ),
                          CustomHorizontalDiver(),
                          CustomListSpaceBetwen(
                            label: 'Solde après',
                            value:
                                '${NumberHelper().formatNumber(thisUser.credits_balance - _cost)} FCFA',
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
                label: 'Payer mon abonnement',
                borderRadius: 50,
                function: _submit,
                bgColor: MyColors().primary,
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
