import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../screens/auth/signup_p2p.dart';
import '../../services/user.dart';
import '../../components/countryPicker/country_picker.dart';
import '../../widgets/common/CustomTextInputLeadingAndIcon.dart';
import '../../widgets/common/custom_alert.dart';
import '../../widgets/common/custom_flat_button_rounded.dart';
import '../../styles/styles.dart';

class SignupP2PChoice extends StatefulWidget {
  @override
  _SignupP2PChoiceState createState() => _SignupP2PChoiceState();
}

class _SignupP2PChoiceState extends State<SignupP2PChoice> {
  String _username;
  int countryCode = 226;
  int localNumberLength = 9;
  String countryFlag = 'BF';
  bool isLoading = false;

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
      _redirectSignupP2P();
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

  void _redirectSignupP2P() {
    Navigator.of(context).pop();
    Navigator.of(context).push(
      CubePageRoute(
        enterPage: SignUpP2PScreen(
          username: '$_username',
          countryCode: countryCode,
          countryFlag: countryFlag,
          numberLength: localNumberLength,
        ),
        exitPage: SignUpP2PScreen(
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
          'Voulez-vous vraiment vous inscrire avec le numéro +$countryCode$_username ?',
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
          'Je m\'inscris (P2P)',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().bgColor,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Column(
            children: [
              Text(
                'Cliquez sur le  drapeau ou sur l\'indicatif pour sélectionner un autre pays',
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              CustomTextInputLeadingAndIcon(
                icon: countryFlag,
                onTapFnc: _openCountryList,
                leadingText: '+${countryCode.toString()}',
                isObscure: false,
                maxLength: localNumberLength,
                maxLines: 1,
                inputType: TextInputType.number,
                labelText:
                    'Entrez le numéro de tél mobile avec lequel vous souhaitez vous inscrire *',
                hintText: '',
                helpText: 'Pas d\'espaces ni de tirets',
                onChanged: (value) {
                  setState(() {
                    _username = value;
                  });
                },
              ),
              if (_username != null && _username.length >= 8)
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
