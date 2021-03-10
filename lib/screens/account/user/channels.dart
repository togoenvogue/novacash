import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../../screens/account/dashboard.dart';
import '../../../screens/account/matrix_p2p_silver/dashboard.dart';
import '../../../models/user.dart';
import '../../../screens/auth/login.dart';
import '../../../services/user.dart';
import '../../../widgets/common/custom_text_input.dart';
import '../../../styles/styles.dart';
import '../../../widgets/common/logo.dart';
import '../../../widgets/common/custom_flat_button_rounded.dart';
import '../../../widgets/common/custom_alert.dart';

class UserChannelsScreen extends StatefulWidget {
  @override
  _UserChannelsScreenState createState() => _UserChannelsScreenState();
}

class _UserChannelsScreenState extends State<UserChannelsScreen> {
  UserModel thisUser;
  TextEditingController _ville = TextEditingController();
  TextEditingController _mobileMoney1 = TextEditingController();
  TextEditingController _mobileMoney2 = TextEditingController();
  TextEditingController _mobileMoney3 = TextEditingController();
  TextEditingController _bitcoin = TextEditingController();
  TextEditingController _ethereum = TextEditingController();
  TextEditingController _payeer = TextEditingController();
  TextEditingController _perfectMoney = TextEditingController();
  TextEditingController _paypal = TextEditingController();
  String username;
  String password;
  bool isLoading = false;
  bool savePassword = true;
  String matrixToLoad;
  String channel_cash; // ignore: non_constant_identifier_names
  String channel_btc; // ignore: non_constant_identifier_names
  String channel_eth; // ignore: non_constant_identifier_names
  String channel_mobile1; // ignore: non_constant_identifier_names
  String channel_mobile2; // ignore: non_constant_identifier_names
  String channel_mobile3; // ignore: non_constant_identifier_names
  String channel_py; // ignore: non_constant_identifier_names
  String channel_pm; // ignore: non_constant_identifier_names
  String channel_pp; // ignore: non_constant_identifier_names

  void _confirm() {
    if (_ville.text != null && _ville.text.length >= 5) {
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).confirm(
        cancelFn: () {},
        cancelText: 'Annuler',
        confirmFn: _submit,
        content: Text(
          'Les paiements ne vous parviendront pas si vous entrez des moyens de paiement erronnés',
          textAlign: TextAlign.center,
        ),
        context: context,
        submitText: 'D\'accord',
        title: 'Confirmez',
      );
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

  void _submit() async {
    // Trigger the loading
    CustomAlert().loading(context: context, dismiss: false, isLoading: true);
    // call the login service
    var result = await AuthService().updateChannels(
      channel_btc: channel_btc,
      channel_cash: channel_cash,
      channel_eth: channel_eth,
      channel_mobile1: channel_mobile1,
      channel_mobile2: channel_mobile2,
      channel_mobile3: channel_mobile3,
      channel_pm: channel_pm,
      channel_py: channel_py,
      channel_pp: channel_pp,
      userKey: thisUser.key,
    );
    // dismiss loading
    Navigator.of(context).pop();
    if (result.error == null) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        CubePageRoute(
          enterPage: result.novaCashP2PSilver == false
              ? P2PSilverDashBoardScreen(userObj: result)
              : DashboardScreen(
                  userObj: result,
                ),
          exitPage: result.novaCashP2PSilver == false
              ? P2PSilverDashBoardScreen(userObj: result)
              : DashboardScreen(
                  userObj: result,
                ),
          duration: const Duration(milliseconds: 300),
        ),
      );
    } else {
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(context, 'Oops!', result.error, true);
    }
  }

  void _getUser() async {
    var uzr = await AuthService().getThisUser();
    if (uzr.error == null) {
      setState(() {
        thisUser = uzr;
        _ville.text = uzr.channel_cash;
        _bitcoin.text = uzr.channel_btc;
        _ethereum.text = uzr.channel_eth;
        _mobileMoney1.text = uzr.channel_mobile1;
        _mobileMoney2.text = uzr.channel_mobile2;
        _mobileMoney3.text = uzr.channel_mobile3;
        _payeer.text = uzr.channel_py;
        _perfectMoney.text = uzr.channel_pm;
        _paypal.text = uzr.channel_pp;
        // set values
        channel_cash = uzr.channel_cash;
        channel_btc = uzr.channel_btc;
        channel_eth = uzr.channel_eth;
        channel_mobile1 = uzr.channel_mobile1;
        channel_mobile2 = uzr.channel_mobile2;
        channel_mobile3 = uzr.channel_mobile3;
        channel_py = uzr.channel_py;
        channel_pm = uzr.channel_pm;
        channel_pp = uzr.channel_pp;
      });
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
      backgroundColor: MyColors().bgColor,
      appBar: AppBar(
        title: Text(
          'Canaux de paiement',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().bgColor,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: thisUser != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Image.asset(
                          'assets/images/icon-channels.png',
                        ),
                        height: 50,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Configuration des canaux appropriés par lesquels vous souhaitez recevoir directement vos paiements',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      CustomTextInput(
                        isObscure: false,
                        maxLines: 1,
                        inputType: TextInputType.text,
                        labelText: 'Quartier (ville) *',
                        helpText: 'Ex: Koulouba (Ouagadougou)',
                        controller: _ville,
                        onChanged: (value) {
                          setState(() {
                            channel_cash = value;
                          });
                        },
                      ),
                      CustomTextInput(
                        isObscure: false,
                        maxLines: 1,
                        inputType: TextInputType.text,
                        labelText: 'Mobile Money Principal',
                        helpText: 'Ex: +226 01778984 (Moov Money)',
                        controller: _mobileMoney1,
                        onChanged: (value) {
                          setState(() {
                            channel_mobile1 = value;
                          });
                        },
                      ),
                      CustomTextInput(
                        isObscure: false,
                        maxLines: 1,
                        inputType: TextInputType.text,
                        labelText: 'Mobile Money Secondaire',
                        helpText: 'Ex: +226 78990873 (Orange Money)',
                        hintText: '(Ce champ est facultatif)',
                        controller: _mobileMoney2,
                        onChanged: (value) {
                          setState(() {
                            channel_mobile2 = value;
                          });
                        },
                      ),
                      CustomTextInput(
                        isObscure: false,
                        maxLines: 1,
                        inputType: TextInputType.text,
                        labelText: 'Mobile Money 3',
                        helpText: 'Ex: +225 45100098 (MTN Money)',
                        hintText: '(Ce champ est facultatif)',
                        controller: _mobileMoney3,
                        onChanged: (value) {
                          setState(() {
                            channel_mobile3 = value;
                          });
                        },
                      ),
                      CustomTextInput(
                        isObscure: false,
                        maxLines: 2,
                        borderRadius: 10,
                        inputType: TextInputType.multiline,
                        labelText: 'Votre adresse Bitcoin',
                        helpText: '(Ce champ est facultatif)',
                        controller: _bitcoin,
                        onChanged: (value) {
                          setState(() {
                            channel_btc = value;
                          });
                        },
                      ),
                      CustomTextInput(
                        isObscure: false,
                        maxLines: 2,
                        borderRadius: 10,
                        inputType: TextInputType.multiline,
                        labelText: 'Votre adresse Ethereum',
                        helpText: '(Ce champ est facultatif)',
                        controller: _ethereum,
                        onChanged: (value) {
                          setState(() {
                            channel_eth = value;
                          });
                        },
                      ),
                      CustomTextInput(
                        isObscure: false,
                        maxLines: 1,
                        inputType: TextInputType.text,
                        labelText: 'Votre compte Perfect Money',
                        helpText: '(facultatif)',
                        controller: _perfectMoney,
                        onChanged: (value) {
                          setState(() {
                            channel_pm = value;
                          });
                        },
                      ),
                      CustomTextInput(
                        isObscure: false,
                        maxLines: 1,
                        inputType: TextInputType.text,
                        labelText: 'Votre compte Paypal',
                        helpText: '(facultatif)',
                        controller: _paypal,
                        onChanged: (value) {
                          setState(() {
                            channel_pp = value;
                          });
                        },
                      ),
                      CustomTextInput(
                        isObscure: false,
                        maxLines: 1,
                        inputType: TextInputType.text,
                        labelText: 'Votre compte Payeer',
                        helpText: '(Ce champ est facultatif)',
                        controller: _payeer,
                        onChanged: (value) {
                          setState(() {
                            channel_py = value;
                          });
                        },
                      ),
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
                      SizedBox(height: 15),
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ),
      ),
    );
  }
}
