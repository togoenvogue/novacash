import 'package:flutter/material.dart';
import 'package:custom_radio_grouped_button/CustomButtons/ButtonTextStyle.dart';
import 'package:custom_radio_grouped_button/CustomButtons/CustomRadioButton.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../components/number_increment/number_increment.dart';
import '../../widgets/common/custom_card.dart';
import '../../services/token.dart';
import '../../screens/public/apn/apn.dart';
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
import '../../services/user.dart';
import '../../widgets/common/custom_alert.dart';

class SignUpStep1Screen extends StatefulWidget {
  final String cryptoCode;
  final int countryCode;
  final String countryFlag;
  final String username;
  @required
  final int numberLength;
  SignUpStep1Screen({
    this.cryptoCode,
    this.countryCode,
    this.countryFlag,
    this.numberLength,
    this.username,
  });
  @override
  _SignUpStep1ScreenState createState() => _SignUpStep1ScreenState();
}

class _SignUpStep1ScreenState extends State<SignUpStep1Screen> {
  String _username;
  String _email;
  String _password1;
  String _password2;
  String _firstName;
  String _lastName;
  String _code;
  String _sponsorUsername;
  String _sponsorFullName;
  int countryCode;
  int localNumberLength;
  String countryFlag;
  int _age;
  String _sex;
  //bool isCodeParrainValid = false;
  List<CountryModel> records = [];
  bool isCodeValid = false;
  bool isSponsorValid = false;
  bool isAgeAndSexSet = false;
  bool isUsernameValid = false;
  bool _codeReadOnly = true;
  bool _usernameReadOnly = true;
  bool _disableModal = true;
  final _usernameController = TextEditingController();
  final _sponsorController = TextEditingController();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _password1Controller = TextEditingController();
  final _password2Controller = TextEditingController();
  dynamic _codeController = TextEditingController();

  void _setSex(String selectedSex) {
    setState(() {
      _sex = selectedSex;
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

  void _redirectToApnList() {
    Navigator.of(context).pushReplacement(
      CubePageRoute(
        enterPage: ApnScreen(),
        exitPage: ApnScreen(),
        duration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _setSponsorActive({String fullName}) {
    setState(() {
      isSponsorValid = true;
      _sponsorFullName = fullName;
    });
  }

  void _createUser() async {
    setState(() {
      isLoading = true;
    });
    CustomAlert()
        .loading(context: context, dismiss: false, isLoading: isLoading);
    var result = await AuthService().signup(
      sponsorUsername: _sponsorUsername,
      email: _email,
      firstName: _firstName,
      lastName: _lastName,
      password: _password1,
      code: _code,
      username: '$countryCode$_username',
      sex: _sex,
      age: _age,
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
        'Votre compte a été créé avec succès. Inscrivez rapidement 2 personnes pour commencer par recevoir 3 500 Fcfa à l\'infini',
        false,
      );
      // redirect after 5 seconds
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
  }

  void _submit() async {
    if (_sex != null && _age != null && _age >= 16 && _age <= 99) {
      setState(() {
        isAgeAndSexSet = true;
      });
      // OK continue
      if (_code != null &&
          _code.length == 16 &&
          !isCodeValid &&
          !isSponsorValid) {
        // verify code
        setState(() {
          isLoading = true;
        });
        CustomAlert()
            .loading(context: context, dismiss: false, isLoading: isLoading);
        var token = await TokenService().token(token: _code);
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop(); // wave off the loading

        if (token != null && token.error == null) {
          if (token.amount >= 7000) {
            setState(() {
              isCodeValid = true;
            });
          } else {
            // insufficient amount
            CustomAlert(
              colorBg: Colors.white,
              colorText: Colors.black,
            ).alert(
              context,
              'Désolé!',
              'Ce code a été déjà utilisé. Contactez un point focal pour acheter un code',
              true,
            );
          }
        } else {
          // alert, wrong token
          CustomAlert(
            colorBg: Colors.white,
            colorText: Colors.black,
          ).alert(
            context,
            'Désolé!',
            'Le code que vous avez entré est incorrect. Contactez un point focal pour acheter un code',
            true,
          );
        }
      } else if (isCodeValid &&
          _code != null &&
          _code.length == 16 &&
          !isSponsorValid &&
          _sponsorUsername != null &&
          _sponsorUsername.length >= 11) {
        // check on the sponsor name
        setState(() {
          isLoading = true;
        });
        CustomAlert()
            .loading(context: context, dismiss: false, isLoading: isLoading);
        var user =
            await AuthService().getUserByUsername(username: _sponsorUsername);
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop(); // wave off the loading
        if (user != null && user.error == null) {
          if (user.expiry > DateTime.now().millisecondsSinceEpoch) {
            // confirm
            CustomAlert(
              colorBg: Colors.white,
              colorText: Colors.black,
            ).confirm(
              cancelFn: () {},
              cancelText: 'Non',
              confirmFn: () {
                _setSponsorActive(
                    fullName: '${user.firstName} ${user.lastName}');
              },
              content: Text(
                'Voulez-vous vraiment vous inscrire sous ${user.firstName} ${user.lastName} ?',
                textAlign: TextAlign.center,
              ),
              context: context,
              submitText: 'Oui',
              title: 'Confirmez',
            );
          } else {
            // sponsor is not active
            CustomAlert(
              colorBg: Colors.white,
              colorText: Colors.black,
            ).alert(
              context,
              'Désolé!',
              'Le membre ${user.firstName} ${user.lastName} ne peut pas vous parrainer car il n\'est pas actif. Demandez-lui de faire son autoship',
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
            user.error,
            true,
          );
        }
      } else if (isCodeValid && isSponsorValid) {
        //print('signup_step1.dart');
        // code and sponsor is OK, process
        if ('$countryCode$_username' != null &&
            '$countryCode$_username'.length >= 11 &&
            '$countryCode$_username'.length <=
                countryCode.toString().length + localNumberLength &&
            !'$countryCode$_username'.startsWith('+') &&
            !'$countryCode$_username'.startsWith('00')) {
          if (_firstName != null &&
              _firstName.length > 0 &&
              _firstName.length <= 50 &&
              _lastName.length <= 50) {
            if (_password1 != null &&
                _password1.length >= 6 &&
                _password1.length <= 20) {
              if (_password2 != null && _password2 == _password1) {
                if (_sponsorUsername != null && _sponsorUsername.length >= 11) {
                  // OK to go
                  // confirm phone number and note password
                  CustomAlert(
                    colorBg: Colors.white,
                    colorText: Colors.black,
                  ).confirm(
                    cancelFn: () {},
                    cancelText: 'Annuler',
                    confirmFn: _createUser,
                    content: Text(
                      '''Votre tél: $countryCode$_username
Mot de passe: $_password1''',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    context: context,
                    submitText: 'Valider',
                    title: 'Confirmez',
                  );
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
              'Entrez votre nom et prénom(s) tels sur votre pièce d\'identité',
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
    } else {
      // selectionnez votre sexe indiquez  votre age (entre 16 et 99 ans)
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Attention!',
        'Sélectionnez votre sexe et indiquez votre âge (entre 16 et 99 ans)',
        true,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_selectCountry();
    //print(widget.countryCode);
    //print(widget.username);
    //print('widget.length: ${widget.numberLength}');
    setState(() {
      countryCode = widget.countryCode;
      countryFlag = widget.countryFlag;
      localNumberLength = widget.numberLength;
      _usernameController.text = widget.username;
      _username = '${widget.username}';
      _sponsorController.text = '';
      _codeController.text = widget.cryptoCode;

      isSponsorValid = false;
      if (widget.cryptoCode != null) {
        _code = widget.cryptoCode;
        _codeReadOnly = true;
        _usernameReadOnly = true;
        isUsernameValid = true;
        isCodeValid = true;
      } else {
        _codeReadOnly = false;
        _usernameReadOnly = true;
        isUsernameValid = false;
        isCodeValid = false;
        _code = null;
      }
    });
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              children: [
                SizedBox(height: 10),
                Logo(),
                SizedBox(height: 10),
                if (isCodeValid == false)
                  CustomFlatButtonRounded(
                    label: 'Besoin d\'un code? Cliquez ici',
                    borderRadius: 50,
                    function: _redirectToApnList,
                    bgColor: Colors.transparent,
                    textColor: Colors.white,
                    borderColor: Colors.redAccent.withOpacity(0),
                  ),
                if (isAgeAndSexSet == false)
                  CustomCard(
                    content: Column(
                      children: [
                        Text('Sélectionnez votre sexe'),
                        CustomRadioButton(
                          buttonValues: ['F', 'M'],
                          buttonLables: ['Féminin', 'Masculin'],
                          radioButtonValue: (value) {
                            _setSex(value);
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
                          width: 120,
                          elevation: 0,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Cliquez sur le (+) pour indiquer votre âge',
                          textAlign: TextAlign.center,
                        ),
                        CustomNumberIncrement(
                          defaultValue: 0,
                          interval: 1,
                          textColor: Color(0xff47b568),
                          minValue: 16,
                          maxValue: 99,
                          callBack: (selectedAge) {
                            setState(() {
                              _age = selectedAge;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                //if (isCodeValid && isSponsorValid)
                /*Text(
                    _code,
                    style: TextStyle(
                      color: Color(0xffccffc4),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),*/
                if (isSponsorValid && _sponsorFullName != null)
                  Text(
                    _sponsorFullName,
                    style: TextStyle(
                      color: Colors.yellow,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                if (isCodeValid == false && isAgeAndSexSet == true)
                  CustomTextInput(
                    isObscure: false,
                    maxLines: 1,
                    maxLength: 16,
                    readOnly: _codeReadOnly,
                    controller: _codeController,
                    inputType: TextInputType.text,
                    labelText: 'Code de validation',
                    helpText: 'Ex: 16135-90376-7TZW',
                    onChanged: (cd) {
                      setState(() {
                        _code = cd;
                      });
                    },
                  ),
                if (isCodeValid &&
                    !isSponsorValid &&
                    _sex != null &&
                    _age != null &&
                    _age >= 16)
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
                if (isSponsorValid &&
                    isUsernameValid == false &&
                    _sex != null &&
                    _age != null)
                  CustomTextInputLeadingAndIcon(
                    icon: countryFlag,
                    onTapFnc: _openCountryList,
                    disableModal: _disableModal,
                    leadingText: '+${countryCode.toString()}',
                    isObscure: false,
                    maxLength: localNumberLength,
                    maxLines: 1,
                    readOnly: _usernameReadOnly,
                    controller: _usernameController,
                    inputType: TextInputType.number,
                    labelText:
                        'Votre numéro de téléphone mobile qui vous servira de username *',
                    hintText: '',
                    helpText: 'Pas d\'espaces ni de tirets',
                    onChanged: (value) {
                      setState(() {
                        _username = value;
                      });
                    },
                  ),
                if (isSponsorValid)
                  CustomTextInput(
                    isObscure: false,
                    maxLines: 1,
                    maxLength: 50,
                    inputType: TextInputType.emailAddress,
                    labelText: 'Votre adresse email*',
                    controller: _emailController,
                    helpText: 'Entrez une adresse valide',
                    onChanged: (value) {
                      setState(() {
                        _email = value;
                      });
                    },
                  ),
                if (isSponsorValid)
                  CustomTextInput(
                    isObscure: false,
                    maxLength: 50,
                    maxLines: 1,
                    inputType: TextInputType.text,
                    labelText: 'Votre nom de famille *',
                    //hintText: 'Ex: SAWADOGO VINCENT',
                    helpText: 'Tel sur votre pièce d\'identité',
                    controller: _lastNameController,
                    onChanged: (value) {
                      setState(() {
                        _lastName = value.toUpperCase();
                      });
                    },
                  ),
                if (isSponsorValid)
                  CustomTextInput(
                    isObscure: false,
                    maxLength: 50,
                    maxLines: 1,
                    inputType: TextInputType.text,
                    labelText: 'Prénom(s) *',
                    //hintText: 'Ex: SAWADOGO VINCENT',
                    helpText: 'Tel sur votre pièce d\'identité',
                    controller: _firstNameController,
                    onChanged: (value) {
                      setState(() {
                        _firstName = value.toUpperCase();
                      });
                    },
                  ),
                if (isSponsorValid)
                  CustomTextInput(
                    isObscure: false,
                    maxLines: 1,
                    maxLength: 20,
                    inputType: TextInputType.number,
                    controller: _password1Controller,
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
                if (isSponsorValid)
                  CustomTextInput(
                    isObscure: false,
                    maxLines: 1,
                    maxLength: 20,
                    inputType: TextInputType.number,
                    controller: _password2Controller,
                    labelText: 'Confirmez votre mot de passe *',
                    hintText: '',
                    helpText: 'Composé de 6 à 20 chiffres',
                    onChanged: (value) {
                      setState(() {
                        _password2 = value;
                      });
                    },
                  ),
                CustomFlatButtonRounded(
                  label: 'Valider',
                  borderRadius: 50,
                  function: () {
                    _submit();
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
      ),
    );
  }
}
