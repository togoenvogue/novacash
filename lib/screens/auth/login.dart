import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/user.dart';
import '../../screens/auth/contract.dart';
import '../../config/configuration.dart';
import '../../screens/account/dashboard.dart';
import '../../widgets/common/custom_text_input.dart';
import '../../styles/styles.dart';
import '../../widgets/common/logo.dart';
import '../../widgets/common/custom_flat_button_rounded.dart';
import '../../widgets/common/custom_alert.dart';
import 'password_reset.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final TextEditingController _savedPassword = TextEditingController();
  static final TextEditingController _savedUsername = TextEditingController();
  String username;
  String password;
  bool isLoading = false;
  bool savePassword = true;

  void _login() async {
    if (username != null &&
        username.length >= 11 &&
        password != null &&
        password.length >= 6 &&
        password.length <= 20) {
      // Trigger the loading
      CustomAlert().loading(context: context, dismiss: false, isLoading: true);
      // call the login service
      var result = await AuthService().login(
        adminRequest: false,
        loginRef: username,
        password: password,
        username: username,
      );

      // dismiss loading
      CustomAlert().loading(context: context, dismiss: false, isLoading: false);
      if (result.error == null) {
        // check and save password
        if (savePassword == true) {
          var prefs = await SharedPreferences.getInstance();
          prefs.setString('savedPassword', password);
          prefs.setString('savedUsername', username);
        } else {
          var prefs = await SharedPreferences.getInstance();
          prefs.setString('savedPassword', '');
          prefs.setString('savedUsername', '');
        }

        if (result.conditionsAccepted == true) {
          Navigator.of(context).pushReplacement(
            CubePageRoute(
              enterPage: DashboardScreen(userObj: result),
              exitPage: DashboardScreen(userObj: result),
              duration: const Duration(milliseconds: 300),
            ),
          );
        } else {
          // redirect to conditions
          Navigator.of(context).pushReplacement(
            CubePageRoute(
              enterPage: UserContractScreen(user: result),
              exitPage: UserContractScreen(user: result),
              duration: const Duration(milliseconds: 300),
            ),
          );
        }
      } else {
        CustomAlert(
          colorBg: Colors.white,
          colorText: Colors.black,
        ).alert(context, 'Oops!', result.error, true);
      }
    } else {
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Oops!',
        'Veuillez remplir les champs obligatoires en suivant les instructions',
        true,
      );
    }
  }

  _getCachedCredentials() async {
    var cached = await SharedPreferences.getInstance();
    var cachedPassword = cached.getString('savedPassword');
    var cachedUsername = cached.getString('savedUsername');
    if (cachedUsername != null &&
        cachedPassword != null &&
        cachedPassword.length >= 6) {
      setState(() {
        password = cachedPassword;
        username = cachedUsername;
        _savedPassword.text = cachedPassword;
        _savedUsername.text = cachedUsername;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCachedCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().bgColor,
      appBar: AppBar(
        title: Text(
          'Connexion',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: Color(0xff5A73CB),
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Logo(),
                SizedBox(height: 10),
                CustomTextInput(
                  isObscure: false,
                  maxLength: 11,
                  maxLines: 1,
                  inputType: TextInputType.number,
                  labelText:
                      'Entrez votre numéro de tél. mobile en commençant par l\'indicatif du pays',
                  //hintText: 'Ex: 22678990966',
                  helpText: 'Evitez 00 ou le signe + devant',
                  controller: _savedUsername,
                  onChanged: (value) {
                    setState(() {
                      username = value;
                    });
                  },
                ),
                CustomTextInput(
                  isObscure: true,
                  maxLines: 1,
                  maxLength: 20,
                  inputType: TextInputType.number,
                  labelText: 'Entrez votre mot de passe $appName',
                  helpText: 'Entre 6 et 20 chiffres',
                  controller: _savedPassword,
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Checkbox(
                      value: savePassword,
                      onChanged: (bool value) {
                        setState(() {
                          savePassword = value;
                        });
                      },
                      focusColor: Colors.yellowAccent,
                      activeColor: Colors.redAccent,
                      checkColor: Colors.white,
                      hoverColor: Colors.white,
                    ),
                    Text(
                      'Cocher pour sauvegarder vos données',
                      style: TextStyle(
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                CustomFlatButtonRounded(
                  label: 'Connexion',
                  borderRadius: 50,
                  function: () {
                    _login();
                  },
                  bgColor: MyColors().primary,
                  textColor: Colors.white,
                ),
                CustomFlatButtonRounded(
                  label: 'Mot de passe perdu? Cliquez ici',
                  borderRadius: 50,
                  function: () {
                    Navigator.of(context).pushReplacement(
                      CubePageRoute(
                        enterPage: PasswordResetScreen(),
                        exitPage: PasswordResetScreen(),
                        duration: const Duration(milliseconds: 300),
                      ),
                    );
                  },
                  bgColor: Colors.transparent,
                  textColor: MyColors().primary,
                  borderColor: MyColors().primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
