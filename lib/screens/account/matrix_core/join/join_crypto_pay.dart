import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../../../screens/auth/login.dart';
import '../../../../services/user.dart';
import '../../../../models/user.dart';
import '../../../../services/config.dart';
import '../../../../models/config.dart';
import '../../../../widgets/common/custom_flat_button_rounded.dart';
import '../../../../services/reload.dart';
import '../../../../widgets/common/custom_alert.dart';
import '../../../../widgets/common/custom_card.dart';
import '../../../../styles/styles.dart';
import '../../dashboard.dart';

class MatrixCoreJoinCryptoPay extends StatefulWidget {
  final UserModel sponsor;
  final String userKey;
  final dynamic amountCrypto;
  final String currency;
  final String systemAddress;
  MatrixCoreJoinCryptoPay({
    this.sponsor,
    this.userKey,
    this.systemAddress,
    this.amountCrypto,
    this.currency,
  });
  @override
  _MatrixCoreJoinCryptoPayState createState() =>
      _MatrixCoreJoinCryptoPayState();
}

class _MatrixCoreJoinCryptoPayState extends State<MatrixCoreJoinCryptoPay> {
  AppConfigModel app;
  String _payTo;
  dynamic _amount;
  bool isLoading = false;
  bool hasPendingPayin = false;
  int countDownDuration = 10;
  bool isPaymentValid = false;
  String _paymentMessage =
      'Après le paiement, revenez cliquer sur le bouton Valider le paiement';
  String _instructions =
      'Montant à envoyer (les éventuels frais sont à votre charge. Assurez-vous de les payer)';

  void _getConfigs() async {
    var result = await AppService().app();
    if (result != null && result.error == null) {
      setState(() {
        app = result;
      });
    } else {
      // error
    }
  }

  void _checkPayment() async {
    if (widget.systemAddress != null) {
      //print('...checking payment: ${DateTime.now().microsecondsSinceEpoch}');
      CustomAlert().loading(
        context: context,
        dismiss: false,
        isLoading: true,
      );
      var payin = await ReloadService().payinVerifyAndGenerateToken(
        address: widget.systemAddress,
      );

      Navigator.of(context).pop(); // wave off the loading screen
      if (payin != null && payin.error == null) {
        setState(() {
          isPaymentValid = true;
        });
        // Payement is OK
        // submit account activation
        CustomAlert().loading(
          context: context,
          dismiss: false,
          isLoading: true,
        );
        var result = await AuthService().matrixCoreCreate(
          sponsorUsername: widget.sponsor.username,
          userKey: widget.userKey,
          code: payin.token,
        );
        Navigator.of(context).pop();
        if (result != null && result.error == null) {
          // reselect user
          CustomAlert().loading(
            context: context,
            dismiss: false,
            isLoading: true,
          );
          var user = await AuthService().getThisUser();
          if (user != null && user.error == null) {
            Navigator.of(context).pop();
            CustomAlert(
              colorBg: Colors.white,
              colorText: Colors.black,
            ).alert(
              context,
              'Succès!',
              'Votre matrice PREMIUM a été activée avec succès. Parrainez rapidement 2 personnes pour profiter du programme',
              true,
            );
            await Future.delayed(const Duration(seconds: 6));
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(
              CubePageRoute(
                enterPage: DashboardScreen(userObj: user),
                exitPage: DashboardScreen(userObj: user),
                duration: const Duration(milliseconds: 300),
              ),
            );
          } else {
            Navigator.of(context).pop();
            CustomAlert(
              colorBg: Colors.white,
              colorText: Colors.black,
            ).alert(
              context,
              'Succès!',
              'Votre matrice PREMIUM a été activée avec succès. Parrainez rapidement 2 personnes pour profiter du programme',
              true,
            );
            await Future.delayed(const Duration(seconds: 6));
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(
              CubePageRoute(
                enterPage: LoginScreen(),
                exitPage: LoginScreen(),
                duration: const Duration(milliseconds: 300),
              ),
            );
          }
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
        if (payin.error.contains('complément')) {
          //print('complément: ${result.error}');
          var ext1 = payin.error.split(":");
          var ext2 = ext1[1].split("${widget.currency}");
          setState(() {
            _amount = ext2[0].trim();
            _instructions = payin.error;
            //_controller.pause();
          });
          CustomAlert(
            colorBg: Colors.white,
            colorText: Colors.black,
          ).alert(
            context,
            '${ext2[0].trim()}',
            payin.error,
            true,
          );
        } else {
          // alert
          CustomAlert(
            colorBg: Colors.white,
            colorText: Colors.black,
          ).alert(
            context,
            'Oops!',
            payin.error,
            true,
          );
        }
      }
    }
  }

  void _copyAdress(String value) {
    CustomAlert(
      colorBg: Colors.white,
      colorText: Colors.black,
    ).alert(
      context,
      'OK!',
      'L\'adresse $value a été copiée dans le presse-papier. Procédez au paiement',
      true,
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _payTo = widget.systemAddress;
      _amount = widget.amountCrypto;
    });
    _getConfigs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payez votre adhésion',
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
          child: _payTo != null
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        'Suivez les instructions pour effectuer le paiement, puis revenez sur cette page pour terminer l\'activation de votre matrice Premium',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (isPaymentValid == false)
                      CustomCard(
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _instructions,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              '$_amount ${widget.currency}',
                              style: TextStyle(
                                fontSize: 22,
                                color: MyColors().danger,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (isPaymentValid == false)
                      CustomCard(
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Envoyez votre paiement à',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 3),
                            SelectableText(
                              _payTo,
                              style: TextStyle(
                                fontSize: 13,
                                color: MyColors().danger,
                                fontWeight: FontWeight.bold,
                              ),
                              onTap: () {
                                _copyAdress(_payTo);
                              },
                            ),
                            Text('Cliquez sur l\'adresse pour la copier'),
                          ],
                        ),
                      ),
                    CustomCard(
                      content: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              _paymentMessage,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          isPaymentValid == false
                              ? CustomFlatButtonRounded(
                                  label: 'Valider le paiement',
                                  borderRadius: 50,
                                  function: () {
                                    _checkPayment();
                                  },
                                  borderColor: Colors.white,
                                  bgColor: Colors.green,
                                  textColor: Colors.white,
                                )
                              : Icon(
                                  Icons.check_circle,
                                  size: 45,
                                  color: Colors.green,
                                ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        'Besoin d\'assistance? Discutez avec nous sur WhatsApp',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            FlutterOpenWhatsapp.sendSingleMessage(
                                app.phone2, '');
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Image.asset(
                              'assets/images/icon_whatsapp.png',
                              width: 40,
                            ),
                          ),
                        ),
                        SizedBox(width: 0),
                      ],
                    ),
                    SizedBox(height: 15),
                    //CustomCard(color: Colors.white,
                    //content: Column(children: [],),),
                  ],
                )
              : Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
