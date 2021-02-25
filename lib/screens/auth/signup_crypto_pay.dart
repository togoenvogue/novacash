import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../services/config.dart';
import '../../models/config.dart';
import '../../widgets/common/custom_flat_button_rounded.dart';
import '../../screens/auth/signup_step1.dart';
import '../../services/reload.dart';
import '../../widgets/common/custom_alert.dart';
import '../../widgets/common/custom_card.dart';
import '../../styles/styles.dart';

class SignupCryptoPay extends StatefulWidget {
  final String username;
  final int countryCode;
  final String countryFlag;
  final dynamic amountCrypto;
  final String currency;
  @required
  final String systemAddress;
  final int length;
  SignupCryptoPay({
    this.username,
    this.countryCode,
    this.countryFlag,
    this.length,
    this.systemAddress,
    this.amountCrypto,
    this.currency,
  });
  @override
  _SignupCryptoPayState createState() => _SignupCryptoPayState();
}

class _SignupCryptoPayState extends State<SignupCryptoPay> {
  AppConfigModel app;
  String _payTo;
  //String _selectedChannel;
  //String _username;
  dynamic _amount;
  String _currency;
  //CryptoPayinModel _payin;
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
  //CountDownController _controller = CountDownController();

/*
  void _getPending() async {
    if (widget.systemAddress != null) {
      var result = await ReloadService().payinPending(
        userKey: '${widget.countryCode}${widget.username}',
        currency: _selectedChannel,
      );
      print(result.error);

      if (result != null && result.error == null) {
        setState(() {
          _payin = result;
          _payTo = result.systemAddress;
          _amount = result.amountCrypto;
          _currency = result.currency;
        });
      } else if (result != null && result.status == 'Waiting') {
        //print('paying key: ${result.key}');
        // payment OK, redirect
        Navigator.of(context).pushReplacement(
          CubePageRoute(
            enterPage: SignUpStep1Screen(
              cryptoCode: result.token,
              countryCode: widget.countryCode,
              countryFlag: widget.countryFlag,
              numberLength: widget.length,
              username: widget.username,
            ),
            exitPage: SignUpStep1Screen(
              cryptoCode: result.token,
              countryCode: widget.countryCode,
              countryFlag: widget.countryFlag,
              numberLength: widget.length,
              username: widget.username,
            ),
            duration: const Duration(milliseconds: 300),
          ),
        );
      } else if (result != null && result.error == 'NO_PENDING_FOUND') {
        // create payin

      } else {
        setState(() {
          isLoading = false;
        });
        // error, redirect
        CustomAlert(
          colorBg: Colors.white,
          colorText: Colors.black,
        ).alert(
          context,
          'Oops!',
          result.error,
          false,
        );
      }
    }
  }*/

  void _checkPayment() async {
    if (widget.systemAddress != null) {
      //print('...checking payment: ${DateTime.now().microsecondsSinceEpoch}');
      setState(() {
        isLoading = true;
      });
      CustomAlert().loading(
        context: context,
        dismiss: false,
        isLoading: isLoading,
      );
      var result = await ReloadService().payinVerifyAndGenerateToken(
        address: widget.systemAddress,
      );
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop(); // wave off the loading screen

      if (result != null && result.error == null) {
        setState(() {
          isPaymentValid = true;
          _paymentMessage =
              'Votre paiement de $_amount $_currency a été approuvé. Vous serez redirigé pour terminer votre inscription';
        });
        // delay
        await Future.delayed(const Duration(seconds: 6));
        // redirect
        Navigator.of(context).pushReplacement(
          CubePageRoute(
            enterPage: SignUpStep1Screen(
              cryptoCode: result.token,
              countryCode: widget.countryCode,
              countryFlag: widget.countryFlag,
              numberLength: widget.length,
              username: widget.username,
            ),
            exitPage: SignUpStep1Screen(
              cryptoCode: result.token,
              countryCode: widget.countryCode,
              countryFlag: widget.countryFlag,
              numberLength: widget.length,
              username: widget.username,
            ),
            duration: const Duration(milliseconds: 300),
          ),
        );
      } else {
        if (result.error.contains('complément')) {
          //print('complément: ${result.error}');
          var ext1 = result.error.split(":");
          var ext2 = ext1[1].split("${widget.currency}");
          setState(() {
            _amount = ext2[0].trim();
            _instructions = result.error;
            //_controller.pause();
          });
          CustomAlert(
            colorBg: Colors.white,
            colorText: Colors.black,
          ).alert(
            context,
            '${ext2[0].trim()}',
            result.error,
            true,
          );

          //} else if (result.error.contains('complément')) {
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
  }

  void _copyAdress(String value) {
    CustomAlert(
      colorBg: Colors.white,
      colorText: Colors.black,
    ).alert(
      context,
      'Bravo!',
      'L\'adresse $value a été copiée dans le presse-papier. Procédez au paiement',
      true,
    );
  }

  /*
  void _cancel({String payinKey}) async {
    setState(() {
      isLoading = true;
    });
    CustomAlert()
        .loading(context: context, dismiss: false, isLoading: isLoading);
    var result = await ReloadService()
        .payinCancel(userKey: _username, payinKey: _payin.key);
    setState(() {
      isLoading = false;
    });
    CustomAlert()
        .loading(context: context, dismiss: false, isLoading: isLoading);
    if (result.error == null) {
      setState(() {
        hasPendingPayin = false;
        _payin = null;
        _payTo = null;
        _selectedChannel = null;
      });
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Succes!',
        'Votre transaction a été annulée avec succès. Vous pouvez recommencer le processus d\'inscription',
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
        result.error,
        true,
      );
    }
  }*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _payTo = widget.systemAddress;
      _amount = widget.amountCrypto;
      _currency = widget.currency;
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
                        'Suivez les instructions pour effectuer le paiement, puis revenez sur cette page pour poursuivre votre inscription',
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
                              ? /*CircularCountDownTimer(
                                  // Countdown duration in Seconds
                                  duration: countDownDuration,
                                  // Controller to control (i.e Pause, Resume, Restart) the Countdown
                                  controller: _controller,
                                  // Width of the Countdown Widget
                                  width: 60,
                                  // Height of the Countdown Widget
                                  height: 60,
                                  // Default Color for Countdown Timer
                                  color: Colors.white,
                                  // Filling Color for Countdown Timer
                                  fillColor: Colors.green,
                                  // Background Color for Countdown Widget
                                  backgroundColor: null,
                                  // Border Thickness of the Countdown Circle
                                  strokeWidth: 5.0,
                                  // Begin and end contours with a flat edge and no extension
                                  strokeCap: StrokeCap.butt,
                                  // Text Style for Countdown Text

                                  // true for reverse countdown (max to 0), false for forward countdown (0 to max)
                                  isReverse: true,
                                  // true for reverse animation, false for forward animation
                                  isReverseAnimation: true,
                                  // Optional [bool] to hide the [Text] in this widget.
                                  isTimerTextShown: true,
                                  autoStart: true,
                                  key: widget.key,
                                  //autoStart: true,
                                  // Function which will execute when the Countdown Ends
                                  onComplete: () {
                                    _checkPayment();
                                  },
                                )*/
                              CustomFlatButtonRounded(
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
