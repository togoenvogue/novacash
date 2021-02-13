import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';

import 'password_reset.dart';
import '../../components/char/char_list.dart';
import '../../components/char/char_wrapper.dart';
import '../../styles/styles.dart';
import '../../widgets/common/logo.dart';
import '../../widgets/common/custom_flat_button_rounded.dart';
import '../../components/keyboard/keyboard.dart';
import '../../screens/account/dashboard.dart';
import '../../config/configuration.dart';

class LoginWithPinScreen extends StatefulWidget {
  @override
  _LoginWithPinScreenState createState() => _LoginWithPinScreenState();
}

class _LoginWithPinScreenState extends State<LoginWithPinScreen> {
  List<String> _charsList = [];
  List<String> _charsListCopy = [];
  final bool _maskChar = false;

  void _getKeyStroke({int keyStroke}) {
    if (_charsList.length < 5) {
      setState(() {
        _charsList.add(keyStroke.toString());
        if (_maskChar == true) {
          _charsListCopy.add('#');
        } else {
          _charsListCopy.add(keyStroke.toString());
        }
      });
    } else {
      setState(() {
        _charsList = [];
        _charsListCopy = [];
      });
    }
  }

  void _resetCharList() {
    setState(() {
      _charsList = [];
      _charsListCopy = [];
    });
  }

  void _login() {
    Navigator.of(context).pushReplacement(
      CubePageRoute(
        enterPage: DashboardScreen(),
        exitPage: DashboardScreen(),
        duration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().bgColor,
      appBar: AppBar(
        title: Text(
          'Connexion Rapide',
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
              SizedBox(height: 25),
              Logo(),
              Container(
                child: Text(
                  'Saisissez votre code secret betNino',
                  style: MyStyles().paragraph,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10),
              CharWrapper(
                reset: _resetCharList,
                child: CharList(
                  charCount: _charsListCopy.length,
                  charsArray: _charsListCopy,
                ),
              ),
              SizedBox(height: 5),
              VirtualKeyBoard(
                title: 'Entrez votre code secret $appName',
                keyCount: 20,
                keyFnc: _getKeyStroke,
                excludeZero: false,
              ),
              CustomFlatButtonRounded(
                label: 'Connexion rapide',
                borderRadius: 50,
                function: () {
                  _login();
                },
                bgColor: MyColors().primary,
                textColor: Colors.white,
                borderColor: MyColors().primary,
              ),
              CustomFlatButtonRounded(
                label: 'Code secret perdu?',
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
    );
  }
}
