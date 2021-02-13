import 'dart:async';
import 'package:flutter/material.dart';
import 'package:custom_radio_grouped_button/CustomButtons/ButtonTextStyle.dart';
import 'package:custom_radio_grouped_button/CustomButtons/CustomRadioButton.dart';
import 'package:flutter/services.dart';
import 'package:cube_transition/cube_transition.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:ussd/ussd.dart';

import '../../../models/config.dart';
import '../../../services/config.dart';
import '../../../config/configuration.dart';
import '../../../widgets/common/custom_text_input_leading.dart';
import '../../../helpers/common.dart';
import '../../../models/reload.dart';
import '../../../models/user.dart';
import '../../../screens/auth/login.dart';
import '../../../services/reload.dart';
import '../../../services/user.dart';
import '../../../widgets/common/custom_alert.dart';
import '../../../widgets/common/custom_flat_button_rounded.dart';
import '../../../widgets/common/custom_text_input.dart';
import '../../../widgets/common/custom_card.dart';
import '../../../styles/styles.dart';

class ReloadMobileScreen extends StatefulWidget {
  @override
  _ReloadMobileScreenState createState() => _ReloadMobileScreenState();
}

class _ReloadMobileScreenState extends State<ReloadMobileScreen> {
  MobileNetworkModel _mobileOperator;
  String _mobileOperatorKey;
  String _mobileAccount;
  dynamic _amount;
  List<MobileNetworkModel> _mobileNetworks = [];
  List<dynamic> _mobileNetworksLabels = [];
  List<dynamic> _mobileNetworksValues = [];
  int _mobileNumberLength;
  bool isLoading = false;
  bool _isPhoneNumberValid = false;
  bool _processCompleted = false;
  UserModel _thisUser;
  AppConfigModel app;
  dynamic _minimumToLoad;
  var _ussdCodeFinal;

  void _getConfigs() async {
    var result = await AppService().app();
    if (result != null && result.error == null) {
      setState(() {
        app = result;
        _minimumToLoad = result.minimum_deposit;
      });
    }
  }

  void _getMobileNetowks() async {
    setState(() {
      isLoading = true;
    });
    CustomAlert()
        .loading(context: context, dismiss: false, isLoading: isLoading);
    var result =
        await ReloadService().getMobileNetworks(code: _thisUser.countryCode);
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop(); // take off the loading

    if (result != null && result[0].error != 'No data') {
      setState(() {
        _mobileNetworks = result;
        _mobileNumberLength = result[0].local_number_length;
        for (var item in result) {
          _mobileNetworksLabels.add('${item.name}');
          _mobileNetworksValues.add('${item.key}');
        }
      });
      //print(_mobileNetworksLabels);
    } else if (result != null && result[0].error == 'No data') {
      setState(() {
        _mobileNetworks = [];
      });
      Navigator.of(context).pop();
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Désolé!',
        'Aucun opérateur mobile n\'a été configuré dans votre pays pour traiter les paiements mobiles. Contactez-nous pour assistance',
        true,
      );
    } else {
      setState(() {
        _mobileNetworks = [];
      });
      Navigator.of(context).pop();
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Oops!',
        result[0].error,
        true,
      );
    }
  }

  void _selectedOperator({String key}) {
    setState(() {
      _mobileOperator = _mobileNetworks.firstWhere((op) => op.key == key);
      _mobileOperatorKey = key;
    });
  }

  _verifyAccount() async {
    final phoneAccount =
        _thisUser.countryCode.toString() + _mobileAccount.toString();
    setState(() {
      isLoading = true;
    });
    CustomAlert()
        .loading(context: context, dismiss: false, isLoading: isLoading);
    var isNumberValid = await ReloadService()
        .isPhoneNumberValid(phone: int.parse(phoneAccount));
    //print('isNumberValid: $isNumberValid');
    setState(() {
      isLoading = false;
      _isPhoneNumberValid = isNumberValid;
    });
    Navigator.of(context).pop();
  }

  void _relancerUssd() async {
    _launchUssd(_ussdCodeFinal);
  }

  void _process() async {
    // _verifyAccount
    await _verifyAccount();
    //print(_isPhoneNumberValid);
    if (_isPhoneNumberValid == true) {
      setState(() {
        isLoading = true;
      });
      CustomAlert()
          .loading(context: context, dismiss: false, isLoading: isLoading);

      //print('USSD (b): $code');
      // send to the servor to proces
      var payin = await ReloadService().rewloadWithMobilePayin(
        amount: _amount,
        client: _thisUser.countryCode == _mobileOperator.countryCode
            ? _mobileAccount
            : _thisUser.countryCode.toString() + _mobileAccount,
        countryCode: _mobileOperator.countryCode,
        message: null,
        sender: _mobileOperator.mobile_money_name,
        system: _thisUser.countryCode == _mobileOperator.countryCode
            ? _mobileOperator.system_account_national.toString()
            : _mobileOperator.system_account_international.toString(),
        userKey: _thisUser.key,
        ussd: _ussdCodeFinal,
      );

      if (payin != null && payin == true) {
        // alert
        setState(() {
          isLoading = false;
          _processCompleted = true;
        });

        CustomAlert(
          colorBg: Colors.white,
          colorText: Colors.black,
        ).alert(
          context,
          '... dernière étape',
          'Pour finaliser votre dépôt, vous devez entrer votre code PIN ${_mobileOperator.mobile_money_name}',
          false,
        );
        await Future.delayed(const Duration(seconds: 4));

        Navigator.of(context).pop();
        Navigator.of(context).pop();

        final String ussdNat = _mobileOperator.ussd_money_send_national;
        var ussdNational = ussdNat.replaceAll(
            'MSDN', _mobileOperator.system_account_national.toString());
        ussdNational = ussdNational.replaceAll('AMOUNT', _amount.toString());
        //ussdNational = ussdNational.replaceAll('PIN', _pinCode.toString());

        final String ussdInt = _mobileOperator.ussd_money_send_international;
        var ussdInternational = ussdInt.replaceAll(
            'MSDN', _mobileOperator.system_account_national.toString());
        ussdInternational =
            ussdInternational.replaceAll('AMOUNT', _amount.toString());
        //ussdInternational = ussdInternational.replaceAll('PIN', _pinCode.toString());
        // send the USSD
        setState(() {
          _ussdCodeFinal = _thisUser.countryCode == _mobileOperator.countryCode
              ? ussdNational
              : ussdInternational;
        }); // ussd code payload
        if (_ussdCodeFinal != null) {
          _launchUssd(_ussdCodeFinal);
          //print('USSD CODE FINAL: $_ussdCodeFinal');
        }
      } else {
        // error
        CustomAlert(
          colorBg: Colors.white,
          colorText: Colors.black,
        ).alert(
          context,
          'Désolé!',
          'Nous n\'avons pas pu initialiser votre dépôt. Vous pouvez essayer de nouveau',
          true,
        );
      }
    } else {
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Désolé!',
        'Il semble que vous avez entré un numéro de téléphone qui n\'est pas pris en compte',
        true,
      );
    }
  }

  Future<void> _launchUssd(String ussdCode) async {
    Ussd.runUssd(ussdCode);
  }

  void _submitConfirm() {
    // check if the user phone number belongs to the network
    if (_mobileOperator.codes.contains(_mobileAccount.substring(0, 2)) &&
        _mobileAccount.toString().length ==
            _mobileOperator.local_number_length) {
      CustomAlert(colorBg: Colors.white, colorText: Colors.black).confirm(
        context: context,
        content: Text(
          'Voulez-vous vraiment faire un dépôt de ${NumberHelper().formatNumber(_amount)} FCFA à partir de votre numéro $_mobileAccount ?',
          textAlign: TextAlign.center,
        ),
        cancelFn: () {},
        confirmFn: _process,
        title: 'Confirmez!',
        cancelText: 'Non',
        submitText: 'Oui',
      );
    } else {
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Désolé!',
        'Il nous semble que $_mobileAccount n\'appartient pas à ${_mobileOperator.name}',
        true,
      );
    }
  }

  void _getUser() async {
    var uzr = await AuthService().getThisUser();
    if (uzr.error == null) {
      setState(() {
        _thisUser = uzr;
      });
      // do any other stuff here
      _getMobileNetowks();
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
    _getConfigs();
    //_printSimCardsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dépôt par Mobile Money',
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
              if (_processCompleted == true)
                CustomCard(
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${_mobileOperator.mobile_money_name}: $_amount F',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.red[300],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        '''Vous avez initialisé une demande de dépôt.

Si vous constatez que cette transaction n\'a pas abouti, alors cliquez sur le bouton suivant pour essayer de nouveau''',
                        style: TextStyle(color: MyColors().primary),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 7),
                      CustomFlatButtonRounded(
                        label: 'Erreur de paiement? Relancer',
                        borderRadius: 50,
                        function: () {
                          _relancerUssd();
                        },
                        bgColor: MyColors().danger,
                        textColor: Colors.white,
                      ),
                      Text(
                        'Bénéficiaire: ${_mobileOperator.system_benef_name}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.red.withOpacity(0.9),
                          fontFamily: MyFontFamily().family4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Dès que la transaction aboutit et est confirmée par ${_mobileOperator.name}, votre compte $appName sera instantanément crédité.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      /*SelectableText(
                        '$_ussdCodeFinal',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: MyFontFamily().family4,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),*/
                      SizedBox(height: 14),
                      Text(
                        'Besoin d\'assistance? Discutez avec nous sur WhatsApp',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        splashColor: Colors.yellow[200],
                        onTap: () {
                          FlutterOpenWhatsapp.sendSingleMessage(app.phone2, '');
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Image.asset(
                            'assets/images/icon_whatsapp.png',
                            width: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 10),
              if (_processCompleted == false &&
                  _mobileNetworks != null &&
                  _mobileNetworks.length > 0)
                CustomCard(
                  content: Column(
                    children: [
                      Text(
                        'Avec quel opérateur mobile souhaitez-vous faire le dépôt?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: MyColors().normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      CustomRadioButton(
                        buttonLables: _mobileNetworksLabels.cast<String>(),
                        buttonValues: _mobileNetworksValues.cast<String>(),
                        radioButtonValue: (value) {
                          _selectedOperator(key: value);
                        },
                        unSelectedColor: MyColors().primary.withOpacity(0.2),
                        selectedColor: MyColors().primary,
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
                        width: 180,
                        elevation: 0,
                      ),
                      if (_mobileOperator != null)
                        Text(
                          'Bénéficiaire: ${_mobileOperator.system_benef_name}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red.withOpacity(0.9),
                            fontFamily: MyFontFamily().family4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                ),
              if (_mobileOperatorKey != null &&
                  _thisUser != null &&
                  _mobileOperator != null &&
                  _processCompleted == false)
                CustomTextInputLeading(
                  labelText:
                      'Entrez le numéro de tél. mobile avec lequel vous souhaitez effectuer le dépôt',
                  isObscure: false,
                  maxLines: 1,
                  inputType: TextInputType.number,
                  maxLength: _mobileNumberLength,
                  helpText: 'Le numéro doit être dans ce tél',
                  leadingText: _thisUser.countryCode.toString(),
                  onChanged: (value) {
                    setState(() {
                      _mobileAccount = value;
                    });
                  },
                ),
              if (_mobileAccount != null && _processCompleted == false)
                CustomTextInput(
                  labelText:
                      'Combien souhaitez-vous déposer sur votre compte $appName? (FCFA)',
                  isObscure: false,
                  maxLines: 1,
                  inputType: TextInputType.number,
                  maxLength: 7,
                  helpText:
                      'Minimum à déposer: ${NumberHelper().formatNumber(_minimumToLoad)} FCFA',
                  onChanged: (amout) {
                    setState(() {
                      _amount = int.parse(amout);
                    });
                  },
                ),
              if (_mobileAccount != null &&
                  _processCompleted == false &&
                  _minimumToLoad != null &&
                  _amount != null &&
                  _amount >= _minimumToLoad)
                CustomFlatButtonRounded(
                  label: 'Valider',
                  borderRadius: 50,
                  function: () {
                    _submitConfirm();
                  },
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
