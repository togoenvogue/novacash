import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../../helpers/common.dart';
import '../../../models/user.dart';
import '../../../screens/account/transfert/transferts.dart';
import '../../../screens/auth/login.dart';
import '../../../services/transfert.dart';
import '../../../services/user.dart';
import '../../../widgets/common/custom_alert.dart';
import '../../../widgets/common/custom_card.dart';
import '../../../widgets/common/custom_flat_button_rounded.dart';
import '../../../widgets/common/custom_horizontal_diver.dart';
import '../../../widgets/common/custom_list_space_between.dart';
import '../../../widgets/common/custom_text_input.dart';
import '../../../styles/styles.dart';

class TransfertCreateScreen extends StatefulWidget {
  @override
  _TransfertCreateScreenState createState() => _TransfertCreateScreenState();
}

class _TransfertCreateScreenState extends State<TransfertCreateScreen> {
  UserModel thisUser;
  String benef;
  String _benefKey;
  bool isLoading;
  dynamic _amount = 0;

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
    if (_benefKey != null && _benefKey != thisUser.key) {
      CustomAlert().loading(context: context, dismiss: false, isLoading: true);
      var result = await TransfertService().transfertCreate(
        amount: _amount,
        fromKey: thisUser.key,
        toKey: _benefKey,
      );
      Navigator.of(context).pop(); // wave off the loading spinner
      if (result != null && result.error == null) {
        CustomAlert(
          colorBg: Colors.white,
          colorText: Colors.black,
        ).alert(
          context,
          'Succès!',
          'Votre transfert de $_amount FCFA s\'est déroulé avec succès!',
          false,
        );
        await Future.delayed(const Duration(seconds: 4));
        Navigator.of(context).pop(); // wave off the confirmation alert
        // redirect
        Navigator.of(context).pushReplacement(
          CubePageRoute(
            enterPage: TransfertsScreen(),
            exitPage: TransfertsScreen(),
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
    } else {
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Attention!',
        'Vous devez indiquer le bénéficiaire du transfert (autre que vous)',
        true,
      );
    }
  }

  void _submitConfirm() async {
    if (benef != null && benef.length >= 11) {
      if (_amount <= thisUser.credits_balance) {
        CustomAlert()
            .loading(context: context, dismiss: false, isLoading: true);
        // get benef
        var result = await AuthService().getUserByUsername(username: benef);
        Navigator.of(context).pop();

        if (result != null && result.error == null) {
          setState(() {
            _benefKey = result.key;
          });
          CustomAlert(
            colorBg: Colors.white,
            colorText: Colors.black,
          ).confirm(
            cancelFn: () {},
            cancelText: 'Non',
            confirmFn: _submit,
            content: Text(
              'Voulez-vous vraiment transférer $_amount FCFA à ${result.firstName} ${result.lastName} ?',
              textAlign: TextAlign.center,
            ),
            context: context,
            submitText: 'Oui',
            title: 'Confirmez!',
          );
        } else {
          // error
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
      } else {
        CustomAlert(
          colorBg: Colors.white,
          colorText: Colors.black,
        ).alert(
          context,
          'Attention!',
          'Entrez un montant inférieur ou égal à ${thisUser.credits_balance} FCFA',
          true,
        );
      }
    } else {
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Attention!',
        'Vous devez entrer un numéro de téléphone valide',
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
          'Nouveau transfert',
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
                'assets/images/icon-transfert.png',
                //fit: BoxFit.cover,
              ),
              //decoration: BoxDecoration(color: Colors.green),
              height: 70,
              //width: double.infinity,
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Transférez une partie de vos gains à un autre membre (sans frais)',
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
                          CustomTextInput(
                            isObscure: false,
                            maxLength: 11,
                            maxLines: 1,
                            inputType: TextInputType.number,
                            labelText: 'Montant à transférer (FCFA)',
                            helpText: 'Minimum: 100 FCFA',
                            onChanged: (value) {
                              setState(() {
                                _amount = int.parse(value);
                              });
                            },
                          ),
                          CustomTextInput(
                            isObscure: false,
                            maxLength: 11,
                            maxLines: 1,
                            inputType: TextInputType.number,
                            labelText: 'Numéro du bénéficiaire',
                            helpText: 'Ex. 22679000865',
                            onChanged: (value) {
                              setState(() {
                                benef = value;
                              });
                            },
                          ),
                          CustomListSpaceBetwen(
                            label: 'Montant à transferer',
                            value:
                                '${NumberHelper().formatNumber(_amount)} FCFA',
                          ),
                          CustomHorizontalDiver(),
                          CustomListSpaceBetwen(
                            label: 'Solde avant',
                            value:
                                '${thisUser.key == '5555555' ? NumberHelper().formatNumber(thisUser.credits_balance) : NumberHelper().formatNumber(thisUser.ewallet_balance)} FCFA',
                          ),
                          CustomHorizontalDiver(),
                          CustomListSpaceBetwen(
                            label: 'Solde après',
                            value:
                                '${thisUser.key == '5555555' ? NumberHelper().formatNumber(thisUser.credits_balance - _amount) : NumberHelper().formatNumber(thisUser.ewallet_balance - _amount)} FCFA',
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
                label: 'Valider le transfert',
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
