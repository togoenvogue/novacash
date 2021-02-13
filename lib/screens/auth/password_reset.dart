import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../services/user.dart';
import '../../widgets/common/custom_alert.dart';
import '../../screens/auth/login.dart';
import '../../widgets/common/custom_text_input.dart';
import '../../styles/styles.dart';
import '../../widgets/common/logo.dart';
import '../../widgets/common/custom_flat_button_rounded.dart';

class PasswordResetScreen extends StatefulWidget {
  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  String username;
  String fullName;

  void _resetPassword() async {
    if (username != null &&
        fullName != null &&
        username.length >= 11 &&
        fullName.length > 0 &&
        fullName.length <= 50) {
      CustomAlert().loading(context: context, dismiss: false, isLoading: true);
      var result = await AuthService()
          .requestPassword(fullName: fullName, username: username);
      CustomAlert().loading(context: context, dismiss: false, isLoading: false);

      if (result.error == null) {
        // success
        CustomAlert(
          colorBg: Colors.white,
          colorText: Colors.black,
        ).alert(
          context,
          'Felicitations!',
          'Vous recevrez un nouveau mot de passe par SMS dans un moment. Vous pouvez le changer après connexion',
          true,
        );
        /*
    Navigator.of(context).pushReplacement(
      CubePageRoute(
        enterPage: LoginScreen(),
        exitPage: LoginScreen(),
        duration: const Duration(milliseconds: 300),
      ),
    );
    */
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
        'Entrez un numéro de 11 ou 12 chifres et votre nom et prénom(s) de 50 caractères maximum',
        true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().bgColor,
      appBar: AppBar(
        title: Text(
          'Mot de passe perdu',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: Color(0xff5A73CB),
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Logo(),
              CustomTextInput(
                isObscure: false,
                maxLength: 11,
                maxLines: 1,
                inputType: TextInputType.number,
                labelText:
                    'Entrez votre numéro de tél. mobile en commençant par l\'indicatif du pays',
                //hintText: 'Ex: 22678990966',
                helpText: 'Evitez 00 ou le signe + devant',
                onChanged: (value) {
                  setState(() {
                    username = value;
                  });
                },
              ),
              CustomTextInput(
                isObscure: false,
                maxLength: 50,
                maxLines: 1,
                inputType: TextInputType.text,
                labelText: 'Entrez votre NOM suivi de votre ou de vos PRENOMS',
                hintText: '',
                helpText: 'Comme lors de votre inscription',
                onChanged: (value) {
                  setState(() {
                    fullName = value;
                  });
                },
              ),
              CustomFlatButtonRounded(
                label: 'Envoyez-moi un mot de passe',
                borderRadius: 50,
                function: () {
                  _resetPassword();
                },
                bgColor: MyColors().primary,
                textColor: Colors.white,
              ),
              CustomFlatButtonRounded(
                label: 'Membre? Connectez-vous',
                borderRadius: 50,
                function: () {
                  Navigator.of(context).pushReplacement(
                    CubePageRoute(
                      enterPage: LoginScreen(),
                      exitPage: LoginScreen(),
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
    );
  }
}
