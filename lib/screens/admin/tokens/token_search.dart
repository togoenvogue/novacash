import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../../widgets/common/custom_flat_button_rounded.dart';
import '../../../screens/admin/tokens/tokens.dart';
import '../../../widgets/common/custom_card.dart';
import '../../../widgets/common/custom_text_input.dart';
import '../../../models/token.dart';
import '../../../services/token.dart';
import '../../../models/user.dart';
import '../../../screens/auth/login.dart';
import '../../../services/user.dart';
import '../../../widgets/common/custom_alert.dart';
import '../../../styles/styles.dart';
import 'token_list.dart';

class TokenSearchScreen extends StatefulWidget {
  @override
  _TokenSearchScreenState createState() => _TokenSearchScreenState();
}

class _TokenSearchScreenState extends State<TokenSearchScreen> {
  TokenModel record;
  String _token;
  bool isLoading = false;
  UserModel _thisUser;

  void _getRecords({String token}) async {
    if (_token != null && _token.length >= 16) {
      setState(() {
        isLoading = true;
      });
      var result = await TokenService().token(token: token);
      if (result != null && result.error == null) {
        setState(() {
          isLoading = false;
          record = result;
        });
      } else {
        setState(() {
          isLoading = false;
          record = null;
        });
        CustomAlert(
          colorBg: Colors.white,
          colorText: Colors.black,
        ).alert(
          context,
          'Désolé!',
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
        'Entrez un code de 16 caractères, y compris les tirets',
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chercher un code',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().bgColor,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(
              Icons.list,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                CubePageRoute(
                  enterPage: TokensScreen(),
                  exitPage: TokensScreen(),
                  duration: const Duration(milliseconds: 300),
                ),
              );
            },
            tooltip: 'Liste des codes',
          ),
        ],
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 10.0),
          child: Column(
            children: [
              Container(
                child: Image.asset(
                  'assets/images/icon-shield.png',
                  //fit: BoxFit.cover,
                ),
                //decoration: BoxDecoration(color: Colors.green),
                height: 70,
                //width: double.infinity,
              ),
              SizedBox(height: 10),
              if (record != null && isLoading == false)
                TokenList(
                  token: record,
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CustomCard(
                  content: Column(
                    children: [
                      CustomTextInput(
                        isObscure: false,
                        maxLength: 16,
                        maxLines: 1,
                        inputType: TextInputType.number,
                        labelText: 'Entrez le code à chercher',
                        helpText: 'Ex. 16135-75475-YRN7',
                        onChanged: (value) {
                          setState(() {
                            _token = value;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: CustomFlatButtonRounded(
                          label: 'Chercher',
                          borderRadius: 50,
                          function: () {
                            _getRecords(token: _token);
                          },
                          borderColor: Colors.transparent,
                          bgColor: MyColors().bgColor,
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
