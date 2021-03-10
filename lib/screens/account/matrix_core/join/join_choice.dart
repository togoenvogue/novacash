import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';
import 'package:custom_radio_grouped_button/CustomButtons/ButtonTextStyle.dart';
import 'package:custom_radio_grouped_button/CustomButtons/CustomRadioButton.dart';

import '../../../../models/user.dart';
import '../../../../screens/account/matrix_core/join/join_crypto_pay.dart';
import '../../../../services/reload.dart';
import '../../../../screens/account/matrix_core/join/join_token.dart';
import '../../../../services/user.dart';
import '../../../../widgets/common/custom_alert.dart';
import '../../../../widgets/common/custom_card.dart';
import '../../../../widgets/common/custom_flat_button_rounded.dart';
import '../../../../widgets/common/custom_text_input.dart';
import '../../../../styles/styles.dart';

class MatrixCoreJoinChoice extends StatefulWidget {
  final String userKey;
  final String username;
  MatrixCoreJoinChoice({@required this.userKey, @required this.username});
  @override
  _MatrixCoreJoinChoiceState createState() => _MatrixCoreJoinChoiceState();
}

class _MatrixCoreJoinChoiceState extends State<MatrixCoreJoinChoice> {
  final _sponsorController = TextEditingController();
  String _sponsorUsername;
  String _selectedChannel;
  UserModel sponsor;
  bool isLoading = false;

  void _channel(String channel) {
    setState(() {
      _selectedChannel = channel;
    });
  }

  void _confirm() async {
    if (_sponsorUsername != null &&
        _sponsorUsername.length >= 11 &&
        _selectedChannel != null) {
      // check if sponsor has acivated the core matrix
      var result = await AuthService().getUserByUsername(
        username: _sponsorUsername,
      );
      if (result != null && result.error == null) {
        if (result.novaCashCore == true) {
          setState(() {
            sponsor = result;
          });
          CustomAlert(
            colorBg: Colors.white,
            colorText: Colors.black,
          ).confirm(
            cancelFn: () {},
            cancelText: 'Non',
            confirmFn: () {
              if (_selectedChannel == 'CODE') {
                Navigator.of(context).push(
                  CubePageRoute(
                    enterPage: MatrixCoreJoinToken(
                      sponsor: result,
                      userKey: widget.userKey,
                    ),
                    exitPage: MatrixCoreJoinToken(
                      sponsor: result,
                      userKey: widget.userKey,
                    ),
                    duration: const Duration(milliseconds: 300),
                  ),
                );
              } else {
                // generate cryptoAmount
                _verifyPayin(username: widget.username);
              }
            },
            content: Text(
              'Voulez-vous vraiment vous inscrire sous ${result.firstName} ${result.lastName} dans la matrice PREMIUM et payer par $_selectedChannel ?',
              textAlign: TextAlign.center,
            ),
            context: context,
            submitText: 'Oui',
            title: 'Confirmez',
          );
        } else {
          // sponsor has not activated the core matrix
          CustomAlert(
            colorBg: Colors.white,
            colorText: Colors.black,
          ).alert(
            context,
            'Désolé!',
            '${result.firstName} ${result.lastName} ne peut pas vous parrainer car il n\'a pas encore activé lui-même la matrice PREMIUM',
            true,
          );
        }
      } else {
        // error
        CustomAlert(
          colorBg: Colors.white,
          colorText: Colors.black,
        ).alert(
          context,
          'Désolé!',
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
        'Oops!',
        'Sélectionnez un canal de paiement et entrez le numéro (ID) de votre parrain',
        true,
      );
    }
  }

  _verifyPayin({String username}) async {
    CustomAlert().loading(
      context: context,
      dismiss: false,
      isLoading: true,
    );
    var result = await ReloadService().payinPending(
      userKey: widget.userKey,
      currency: _selectedChannel,
      type: 'Signup',
    );

    if (result != null && result.error == null) {
      if (result.status == 'Pending' || result.status == 'Waiting') {
        Navigator.of(context).pop(); // wave off the loading
        Navigator.of(context).pushReplacement(
          CubePageRoute(
            enterPage: MatrixCoreJoinCryptoPay(
              amountCrypto: result.amountCrypto,
              currency: result.currency,
              systemAddress: result.systemAddress,
              sponsor: sponsor,
              userKey: widget.userKey,
            ),
            exitPage: MatrixCoreJoinCryptoPay(
              amountCrypto: result.amountCrypto,
              currency: result.currency,
              systemAddress: result.systemAddress,
              sponsor: sponsor,
              userKey: widget.userKey,
            ),
            duration: const Duration(milliseconds: 300),
          ),
        );
      }
    } else if (result != null && result.error == 'NO_PENDING_FOUND') {
      // create new pending
      var result = await ReloadService().cryptoPayinCreateUsername(
        amount: 7000,
        currency: _selectedChannel,
        username: widget.username,
        type: 'Signup',
      );

      Navigator.of(context).pop(); // wave off the loading
      if (result != null && result.error == null) {
        Navigator.of(context).push(
          CubePageRoute(
            enterPage: MatrixCoreJoinCryptoPay(
              amountCrypto: result.amountCrypto,
              currency: result.currency,
              systemAddress: result.systemAddress,
              sponsor: sponsor,
              userKey: widget.userKey,
            ),
            exitPage: MatrixCoreJoinCryptoPay(
              amountCrypto: result.amountCrypto,
              currency: result.currency,
              systemAddress: result.systemAddress,
              sponsor: sponsor,
              userKey: widget.userKey,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Activer la matrice PREMIUM',
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
                content: Column(
                  children: [
                    Text(
                      'Par quel moyen souhaitez-vous payer l\'activation de votre matrice PREMIUM de 7 000 FCFA?',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    CustomRadioButton(
                      buttonValues: ['CODE', 'BTC', 'ETH'],
                      buttonLables: ['CODE', 'BTC', 'ETH'],
                      radioButtonValue: (value) {
                        _channel(value);
                      },
                      unSelectedColor: MyColors().primary.withOpacity(0.2),
                      selectedColor: MyColors().success,
                      selectedBorderColor: Colors.transparent,
                      unSelectedBorderColor: Colors.black.withOpacity(0.1),
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
              if (_selectedChannel != null)
                CustomTextInput(
                  isObscure: false,
                  maxLines: 1,
                  //maxLength: 11,
                  inputType: TextInputType.number,
                  controller: _sponsorController,
                  labelText:
                      'Entrez le ID (numéro de téléphone) de votre parrain pour continuer (Ex: 22676555543) *',
                  helpText: 'Pas de parrain? Contactez-nous',
                  onChanged: (sp) {
                    setState(() {
                      _sponsorUsername = sp;
                    });
                  },
                ),
              if (_selectedChannel != null &&
                  _sponsorUsername != null &&
                  _sponsorUsername.length >= 11)
                CustomFlatButtonRounded(
                  label: 'Valider',
                  borderRadius: 50,
                  function: () {
                    _confirm();
                  },
                  borderColor: Colors.transparent,
                  bgColor: Colors.green.withOpacity(0.6),
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
