import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';
import 'package:custom_radio_grouped_button/CustomButtons/ButtonTextStyle.dart';
import 'package:custom_radio_grouped_button/CustomButtons/CustomRadioButton.dart';

import '../../services/user.dart';
import '../../components/countryPicker/country_picker.dart';
import '../../screens/auth/signup_crypto_pay.dart';
import '../../screens/auth/signup_step1.dart';
import '../../services/reload.dart';
import '../../widgets/common/CustomTextInputLeadingAndIcon.dart';
import '../../widgets/common/custom_alert.dart';
import '../../widgets/common/custom_card.dart';
import '../../widgets/common/custom_flat_button_rounded.dart';
import '../../styles/styles.dart';

class SignupChoice extends StatefulWidget {
  @override
  _SignupChoiceState createState() => _SignupChoiceState();
}

class _SignupChoiceState extends State<SignupChoice> {
  String _username;
  int countryCode = 226;
  int localNumberLength = 9;
  String countryFlag = 'BF';
  String _selectedChannel;
  bool isLoading = false;

  void _channel(String channel) {
    setState(() {
      _selectedChannel = channel;
    });
  }

  void _openCountryList() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return CountryPicker(
            selectedCountry: _selectedCountry,
          );
        });
  }

  void _selectedCountry(
    dynamic selectedCountry,
    String selectedCountryFlag,
    int length,
  ) {
    //print(selectedCountry);
    //print(length);
    setState(() {
      countryCode = selectedCountry;
      countryFlag = selectedCountryFlag;
      localNumberLength = length;
    });
    Navigator.of(context).pop();
  }

  void _confirmChoice() async {
    setState(() {
      isLoading = true;
    });
    CustomAlert().loading(
      context: context,
      dismiss: false,
      isLoading: isLoading,
    );
    // verify if username is available
    var result = await AuthService().isUsernameFree(
      username: '$countryCode$_username',
    );
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop();
    if (result == false) {
      // username is free, continue
      if (_selectedChannel == 'CODE') {
        _redirectSignupWithCode();
      } else {
        // verify payin
        await _verifyPayin(username: '$countryCode$_username');
      }
    } else {
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Oops!',
        'Le numéro $countryCode$_username est déjà utilisé. Essayez un autre numéro',
        true,
      );
    }
  }

  _verifyPayin({String username}) async {
    setState(() {
      isLoading = true;
    });
    CustomAlert().loading(
      context: context,
      dismiss: false,
      isLoading: isLoading,
    );
    var result = await ReloadService().payinPending(
      userKey: '$countryCode$_username',
      currency: _selectedChannel,
      type: 'Signup',
    );
    setState(() {
      isLoading = false;
    });

    //Navigator.of(context).pop();
    if (result != null && result.error == null) {
      if (result.status == 'Pending') {
        Navigator.of(context).pop();
        Navigator.of(context).push(
          CubePageRoute(
            enterPage: SignupCryptoPay(
              username: '$_username',
              countryCode: countryCode,
              countryFlag: countryFlag,
              length: localNumberLength,
              systemAddress: result.systemAddress,
              amountCrypto: result.amountCrypto,
              currency: result.currency,
            ),
            exitPage: SignupCryptoPay(
              username: '$_username',
              countryCode: countryCode,
              countryFlag: countryFlag,
              length: localNumberLength,
              systemAddress: result.systemAddress,
              amountCrypto: result.amountCrypto,
              currency: result.currency,
            ),
            duration: const Duration(milliseconds: 300),
          ),
        );
        // signup
      } else {
        Navigator.of(context).pop();
        Navigator.of(context).push(
          CubePageRoute(
            enterPage: SignUpStep1Screen(
              username: '$_username',
              countryCode: countryCode,
              countryFlag: countryFlag,
              numberLength: localNumberLength,
              cryptoCode: result.token,
            ),
            exitPage: SignUpStep1Screen(
              username: '$_username',
              countryCode: countryCode,
              countryFlag: countryFlag,
              numberLength: localNumberLength,
              cryptoCode: result.token,
            ),
            duration: const Duration(milliseconds: 300),
          ),
        );
      }
    } else if (result != null && result.error == 'NO_PENDING_FOUND') {
      // create new pending
      setState(() {
        isLoading = true;
      });
      var result = await ReloadService().cryptoPayinCreateUsername(
        amount: 7000,
        currency: _selectedChannel,
        username: '$countryCode$_username',
        type: 'Signup',
      );
      setState(() {
        isLoading = false;
      });
      if (result != null && result.error == null) {
        Navigator.of(context).pop();
        Navigator.of(context).push(
          CubePageRoute(
            enterPage: SignupCryptoPay(
              username: '$_username',
              countryCode: countryCode,
              countryFlag: countryFlag,
              length: localNumberLength,
              systemAddress: result.systemAddress,
              amountCrypto: result.amountCrypto,
              currency: result.currency,
            ),
            exitPage: SignupCryptoPay(
              username: '$_username',
              countryCode: countryCode,
              countryFlag: countryFlag,
              length: localNumberLength,
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

  void _redirectSignupWithCode() {
    Navigator.of(context).pop();
    Navigator.of(context).push(
      CubePageRoute(
        enterPage: SignUpStep1Screen(
          username: '$_username',
          countryCode: countryCode,
          countryFlag: countryFlag,
          numberLength: localNumberLength,
        ),
        exitPage: SignUpStep1Screen(
          username: '$_username',
          countryCode: countryCode,
          countryFlag: countryFlag,
          numberLength: localNumberLength,
        ),
        duration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _confirm() {
    if (_username != null && _username.length >= 8) {
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).confirm(
        cancelFn: () {},
        cancelText: 'Non',
        confirmFn: _confirmChoice,
        content: Text(
          'Voulez-vous vraiment vous inscrire avec le numéro +$countryCode$_username et payer par $_selectedChannel ?',
          textAlign: TextAlign.center,
        ),
        context: context,
        submitText: 'Oui',
        title: 'Confirmez',
      );
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Je m\'inscris',
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
                      'Par quel moyen souhaitez-vous payer votre adhésion de 7 000 FCFA?',
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
              if (_selectedChannel != null)
                CustomTextInputLeadingAndIcon(
                  icon: countryFlag,
                  onTapFnc: _openCountryList,
                  leadingText: '+${countryCode.toString()}',
                  isObscure: false,
                  maxLength: localNumberLength,
                  maxLines: 1,
                  inputType: TextInputType.number,
                  labelText:
                      'Entrez le numéro de téléphone mobile avec lequel vous souhaitez vous inscrire *',
                  hintText: '',
                  helpText: 'Pas d\'espaces ni de tirets',
                  onChanged: (value) {
                    setState(() {
                      _username = value;
                    });
                  },
                ),
              if (_selectedChannel != null &&
                  _username != null &&
                  _username.length >= 8)
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
            ],
          ),
        ),
      ),
    );
  }
}
