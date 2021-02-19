import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../../screens/public/home/home.dart';
import '../../../services/user.dart';
import '../../../styles/styles.dart';
import '../../../widgets/common/custom_alert.dart';
import '../../../widgets/common/custom_flat_button_rounded.dart';
import '../../../widgets/common/custom_text_input.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  String password;
  String passwordNew1;
  String passwordNew2;
  bool isLoading = false;

  void _submit() async {
    if (password.length >= 6 && password.length <= 20) {
      if (passwordNew1.length >= 6 && passwordNew1.length <= 20) {
        if (passwordNew1 == passwordNew2) {
          setState(() {
            isLoading = true;
          });
          CustomAlert()
              .loading(context: context, dismiss: false, isLoading: isLoading);
          var result = await AuthService()
              .changePassword(newPassword: passwordNew1, password: password);

          setState(() {
            isLoading = false;
          });

          if (result.error == null && result.isAuth == true) {
            // success
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(
              CubePageRoute(
                enterPage: HomeScreen(),
                exitPage: HomeScreen(),
                duration: const Duration(milliseconds: 300),
              ),
            );
          } else {
            // error
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
            'Les deux nouveaux mots de passe ne sont pas identiques',
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
          'Entrez un nouveau mot de passe composé de 6 à 20 chiffres',
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
        'Votre mot de passe doit compter entre 6 et 20 chiffres',
        true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Changer mon mot de passe',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().bgColor,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              CustomTextInput(
                labelText: 'Entrez votre mot de passe actuel',
                isObscure: true,
                maxLines: 1,
                inputType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                //helpText: 'Merci de respecter la casse',
              ),
              SizedBox(height: 3),
              CustomTextInput(
                labelText: 'Choisissez un nouveau mot de passe',
                isObscure: true,
                maxLines: 1,
                inputType: TextInputType.text,
                maxLength: 20,
                helpText: 'Entre 6 et 20 chiffres',
                onChanged: (value) {
                  setState(() {
                    passwordNew1 = value;
                  });
                },
              ),
              CustomTextInput(
                labelText: 'Confirmez votre nouveau mot de passe',
                isObscure: true,
                maxLines: 1,
                inputType: TextInputType.text,
                onChanged: (value) {
                  setState(() {
                    passwordNew2 = value;
                  });
                },
              ),
              CustomFlatButtonRounded(
                label: 'Changer mon mot de passe',
                borderRadius: 50,
                function: _submit,
                borderColor: Colors.transparent,
                bgColor: Colors.green.withOpacity(0.6),
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
