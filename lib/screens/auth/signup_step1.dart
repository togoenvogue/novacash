import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../models/country.dart';
import '../../screens/account/expiration/renew.dart';
import '../../screens/auth/login.dart';
import '../../components/countryPicker/country_picker.dart';
import '../../widgets/common/CustomTextInputLeadingAndIcon.dart';
import '../../styles/styles.dart';
import '../../widgets/common/logo.dart';
import '../../widgets/common/custom_text_input.dart';
import '../../widgets/common/custom_flat_button_rounded.dart';
import '../../config/configuration.dart';
import '../../screens/public/static/conditions.dart';
import '../../services/user.dart';
import '../../widgets/common/custom_alert.dart';
import '../../widgets/common/custom_card.dart';

class SignUpStep1Screen extends StatefulWidget {
  @override
  _SignUpStep1ScreenState createState() => _SignUpStep1ScreenState();
}

class _SignUpStep1ScreenState extends State<SignUpStep1Screen> {
  String _username;
  String _adminKey;
  String _email;
  String _password1;
  String _password2;
  String _fullName;
  bool isUsingDefaultSponsor = false;
  int countryCode = 226;
  String countryFlag = 'BF';
  //bool isCodeParrainValid = false;
  List<CountryModel> records = [];

  void _openCountryList() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return CountryPicker(
            selectedCountry: _selectedCountry,
          );
        });
  }

  void _selectedCountry(dynamic selectedCountry, String selectedCountryFlag) {
    //print(selectedCountry);
    //print(selectedCountryFlag);
    setState(() {
      countryCode = selectedCountry;
      countryFlag = selectedCountryFlag;
    });
    Navigator.of(context).pop();
  }

  void _setDefaultSponsor({bool useDefault}) {
    if (useDefault == true) {
      setState(() {
        isUsingDefaultSponsor = true;
        _adminKey = '20000';
      });
    } else {
      setState(() {
        isUsingDefaultSponsor = false;
        _adminKey = null;
      });
    }
  }

  void _setDefaultSponsorConfirm(bool option) {
    CustomAlert().confirm(
      confirmFn: () {
        _setDefaultSponsor(useDefault: option);
      },
      cancelFn: () {},
      cancelText: 'Non',
      submitText: 'Oui',
      content: Text(
        option == true
            ? 'Etes-vous sûr de vouloir utiliser le code d\'invitation du système pour vous inscrire?'
            : 'Etes-vous en possession du code d\'invitation d\'un utilisateur de l\'application?',
        textAlign: TextAlign.center,
      ),
      context: context,
      title: 'Confirmez!',
    );
  }

  void _submit() async {
    if ('$countryCode$_username' != null &&
        '$countryCode$_username'.length >= 11 &&
        '$countryCode$_username'.length <= 12 &&
        !'$countryCode$_username'.startsWith('+') &&
        !'$countryCode$_username'.startsWith('00')) {
      if (_fullName != null && _fullName.length > 0 && _fullName.length <= 50) {
        if (_password1 != null &&
            _password1.length >= 6 &&
            _password1.length <= 20) {
          if (_password2 != null && _password2 == _password1) {
            if (_adminKey != null && _adminKey.length >= 5) {
              // OK to go
              setState(() {
                isLoading = true;
              });
              CustomAlert().loading(
                  context: context, dismiss: false, isLoading: isLoading);
              var result = await AuthService().signup(
                sponsorUsername: '',
                email: _email,
                firstName: '',
                lastName: '',
                password: _password1,
                username: '$countryCode$_username',
              );

              setState(() {
                isLoading = false;
              });
              Navigator.of(context).pop();

              if (result.error == null && result.key != null) {
                // success
                CustomAlert(
                  colorBg: Colors.white,
                  colorText: Colors.black,
                ).alert(
                  context,
                  'Succès!',
                  'Votre compte a été créé avec succès. Mettez à profit votre période d\'essai de 7 jours',
                  false,
                );
                // redirect after 5 seconds
                await Future.delayed(const Duration(seconds: 5));
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  CubePageRoute(
                    enterPage: LoginScreen(),
                    exitPage: LoginScreen(),
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
                'Vous devez entrer un code d\'invitation valide pour continuer',
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
              'Les deux mots de passe ne sont pas identiques. Veuillez les corriger',
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
            'Choisissez un mot de passe pour votre compte $appName en suivant les instructions',
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
          'Entrez votre nom suivi de votre ou de vos prénoms en suivant les instructions',
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
        'Entrez un numéro de téléphone mobile valide en suivant les instructions',
        true,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_selectCountry();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Je m\'inscris',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().primary,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              children: [
                SizedBox(height: 10),
                Logo(),
                SizedBox(height: 10),
                if (isUsingDefaultSponsor)
                  Text(
                    'Vous utilisez actuellement le code d\'invitation du système. Si vous avez le code d\'invitation de celui qui vous a recommandé $appName, utilisez-le!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                if (!isUsingDefaultSponsor)
                  CustomFlatButtonRounded(
                    label: 'Pas de code d\'invitation? Cliquez ici',
                    borderRadius: 50,
                    function: () {
                      _setDefaultSponsorConfirm(true);
                    },
                    bgColor: Colors.redAccent.withOpacity(0.2),
                    textColor: Colors.redAccent.withOpacity(0.8),
                    borderColor: Colors.redAccent.withOpacity(0.5),
                  ),
                if (isUsingDefaultSponsor)
                  CustomFlatButtonRounded(
                    label: 'Utiliser le code de mon parrain',
                    borderRadius: 50,
                    function: () {
                      _setDefaultSponsorConfirm(false);
                    },
                    bgColor: Colors.blue.withOpacity(0.2),
                    textColor: Colors.blue.withOpacity(0.8),
                    borderColor: Colors.blue.withOpacity(0.5),
                  ),
                if (!isUsingDefaultSponsor)
                  CustomTextInput(
                    isObscure: false,
                    maxLines: 1,
                    inputType: TextInputType.text,
                    labelText:
                        'Entrez le code d\'invitation de votre parrain pour continuer (Ex: 988873) *',
                    //hintText: '',
                    helpText:
                        'Besoin d\'un code? Cliquez sur le bouton en haut',
                    onChanged: (value) {
                      setState(() {
                        _adminKey = value;
                      });
                    },
                  ),
                CustomTextInputLeadingAndIcon(
                  icon: countryFlag,
                  onTap: _openCountryList,
                  leadingText: '+${countryCode.toString()}',
                  isObscure: false,
                  maxLength: 11,
                  maxLines: 1,
                  inputType: TextInputType.number,
                  labelText:
                      'Entrez votre numéro de téléphone mobile qui vous servira de username *',
                  hintText: '',
                  helpText: 'Pas d\'espaces ni de tirets',
                  onChanged: (value) {
                    setState(() {
                      _username = value;
                    });
                  },
                ),
                CustomTextInput(
                  isObscure: false,
                  maxLength: 50,
                  maxLines: 1,
                  inputType: TextInputType.text,
                  labelText:
                      'Qui êtes-vous? (en cas d\'oubli de votre mot de passe, vous aurez besoin d\'indiquer votre nom et prénom) *',
                  //hintText: 'Ex: SAWADOGO VINCENT',
                  helpText: 'Nom de famille suivi du ou des prénom(s)',
                  onChanged: (value) {
                    setState(() {
                      _fullName = value.toUpperCase();
                    });
                  },
                ),
                CustomTextInput(
                  isObscure: false,
                  maxLines: 1,
                  maxLength: 20,
                  inputType: TextInputType.number,
                  labelText:
                      'Choisissez un mot de passe pour votre compte $appName *',
                  hintText: '',
                  helpText: 'Composé de 6 à 20 chiffres',
                  onChanged: (value) {
                    setState(() {
                      _password1 = value;
                    });
                  },
                ),
                CustomTextInput(
                  isObscure: false,
                  maxLines: 1,
                  maxLength: 20,
                  inputType: TextInputType.number,
                  labelText: 'Confirmez votre mot de passe *',
                  hintText: '',
                  helpText: 'Composé de 6 à 20 chiffres',
                  onChanged: (value) {
                    setState(() {
                      _password2 = value;
                    });
                  },
                ),
                CustomTextInput(
                  isObscure: false,
                  maxLines: 1,
                  inputType: TextInputType.emailAddress,
                  labelText: 'Votre adresse email',
                  //hintText: 'Ex: johndoe@domain.com',
                  helpText: 'Facultatif mais vivement recommandé',
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                ),
                CustomCard(
                  color: MyColors().danger,
                  content: Column(
                    children: [
                      Text(
                        'En vous validant votre inscription, vous acceptez avoir lu, compris et approuvé les termes et conditions de $appName',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 6),
                      CustomFlatButtonRounded(
                        label: 'Lire les termes et conditions!',
                        borderRadius: 50,
                        function: () {
                          Navigator.of(context).push(
                            CubePageRoute(
                              enterPage: ConditionsScreen(),
                              exitPage: ConditionsScreen(),
                              duration: const Duration(milliseconds: 300),
                            ),
                          );
                        },
                        bgColor: MyColors().white,
                        textColor: Colors.redAccent,
                      ),
                    ],
                  ),
                ),
                CustomFlatButtonRounded(
                  label: 'Tout est OK, créer mon compte!',
                  borderRadius: 50,
                  function: () {
                    _submit();
                  },
                  bgColor: MyColors().primary,
                  textColor: Colors.white,
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
