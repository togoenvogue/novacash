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
  String email;
  bool isLoading = false;

  void _resetPassword() async {
    if (username != null &&
        username.length >= 11 &&
        !username.startsWith('+') &&
        !username.startsWith('00')) {
      if (email != null && email.length > 0 && email.length <= 50) {
        setState(() {
          isLoading = true;
        });
        CustomAlert()
            .loading(context: context, dismiss: false, isLoading: isLoading);
        var result = await AuthService()
            .requestPassword(email: email, username: username);
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop(); // wave off the loading

        if (result != null && result.error == null) {
          // success
          CustomAlert(
            colorBg: Colors.white,
            colorText: Colors.black,
          ).alert(
            context,
            'Succès!',
            'Vous recevrez bientôt un nouveau mot de passe par SMS et/ou par MAIL. Vous pouvez le changer après connexion',
            false,
          );

          await Future.delayed(const Duration(seconds: 5));
          Navigator.of(context).pop(); // wave off the confirmation alert
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
          'Entrez votre adresse email utilisée lors de votre inscription',
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
        'Suivez les instructions pour entrer un numéro de telephone valide',
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
        backgroundColor: MyColors().bgColor,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 5),
              Logo(),
              SizedBox(height: 5),
              CustomTextInput(
                isObscure: false,
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
                inputType: TextInputType.emailAddress,
                labelText: 'Entrez votre adresse email',
                hintText: '',
                helpText: 'Email utilisée pour vous inscrire',
                onChanged: (value) {
                  setState(() {
                    email = value;
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
