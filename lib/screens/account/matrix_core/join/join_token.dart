import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../../../screens/account/dashboard.dart';
import '../../../../screens/auth/login.dart';
import '../../../../services/token.dart';
import '../../../../services/user.dart';
import '../../../../widgets/common/custom_alert.dart';
import '../../../../widgets/common/custom_flat_button_rounded.dart';
import '../../../../widgets/common/custom_text_input.dart';
import '../../../../models/user.dart';
import '../../../../widgets/common/custom_card.dart';
import '../../../../widgets/common/custom_horizontal_diver.dart';
import '../../../../widgets/common/custom_list_space_between.dart';
import '../../../../styles/styles.dart';

class MatrixCoreJoinToken extends StatefulWidget {
  final UserModel sponsor;
  final String userKey;
  MatrixCoreJoinToken({this.sponsor, @required this.userKey});
  @override
  _MatrixCoreJoinTokenState createState() => _MatrixCoreJoinTokenState();
}

class _MatrixCoreJoinTokenState extends State<MatrixCoreJoinToken> {
  String _code;
  bool isLoading;

  void _submit() async {
    if (_code != null && _code.length >= 16) {
      setState(() {
        isLoading = true;
      });
      CustomAlert().loading(
        context: context,
        dismiss: false,
        isLoading: isLoading,
      );
      var token = await TokenService().token(token: _code);
      Navigator.of(context).pop();
      if (token != null && token.error == null) {
        if (token.amount >= 7000) {
          CustomAlert().loading(
            context: context,
            dismiss: false,
            isLoading: isLoading,
          );
          // process
          var result = await AuthService().matrixCoreCreate(
            sponsorUsername: widget.sponsor.username,
            userKey: widget.userKey,
            code: _code,
          );
          Navigator.of(context).pop();
          if (result != null && result.error == null) {
            // reselect user
            var user = await AuthService().getThisUser();
            if (user != null && user.error == null) {
              CustomAlert(
                colorBg: Colors.white,
                colorText: Colors.black,
              ).alert(
                context,
                'Succès!',
                'Votre matrice PREMIUM a été activée avec succès. Parrainez rapidement 2 personnes pour profiter du programme',
                true,
              );
              await Future.delayed(const Duration(seconds: 6));
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                CubePageRoute(
                  enterPage: DashboardScreen(userObj: user),
                  exitPage: DashboardScreen(userObj: user),
                  duration: const Duration(milliseconds: 300),
                ),
              );
            } else {
              CustomAlert(
                colorBg: Colors.white,
                colorText: Colors.black,
              ).alert(
                context,
                'Succès!',
                'Votre matrice PREMIUM a été activée avec succès. Parrainez rapidement 2 personnes pour profiter du programme',
                true,
              );
              await Future.delayed(const Duration(seconds: 6));
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                CubePageRoute(
                  enterPage: LoginScreen(),
                  exitPage: LoginScreen(),
                  duration: const Duration(milliseconds: 300),
                ),
              );
            }
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
          // insufficient amount
          CustomAlert(
            colorBg: Colors.white,
            colorText: Colors.black,
          ).alert(
            context,
            'Désolé!',
            'Ce Token a été déjà utilisé. Contactez un point focal pour acheter un novueau Token',
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
    } else {
      // error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payez par Token (Code)',
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
                content: Column(
                  children: [
                    Text(
                      'Détails de votre parrain',
                    ),
                    CustomListSpaceBetwen(
                      label: 'Nom',
                      value: '${widget.sponsor.lastName}',
                    ),
                    CustomHorizontalDiver(),
                    CustomListSpaceBetwen(
                      label: 'Prénom(s)',
                      value: '${widget.sponsor.firstName}',
                    ),
                    CustomHorizontalDiver(),
                    CustomListSpaceBetwen(
                      label: 'Matrice',
                      value: 'PREMIUM',
                    ),
                  ],
                ),
              ),
              CustomTextInput(
                isObscure: false,
                maxLines: 1,
                //maxLength: 11,
                inputType: TextInputType.text,
                labelText: 'Entrez un Token (Code) valide *',
                helpText: 'Ex: 16150-41864-3ETP',
                onChanged: (value) {
                  setState(() {
                    _code = value;
                  });
                },
              ),
              if (_code != null && _code.length >= 16)
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
    );
  }
}
