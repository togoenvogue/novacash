import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../../widgets/common/empty_folder.dart';
import '../../../helpers/common.dart';
import '../../../styles/styles.dart';
import '../../../widgets/common/custom_card.dart';
import '../../../widgets/common/custom_horizontal_diver.dart';
import '../../../widgets/common/custom_list_vertical.dart';
import '../../../widgets/user/user_profile_picture.dart';
import '../../../models/user.dart';
import '../../../screens/auth/login.dart';
import '../../../services/user.dart';
import '../../../widgets/common/custom_alert.dart';
import 'change_password.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel userObj;
  ProfileScreen({this.userObj});
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel _thisUser;
  bool isLoading = false;

  void _getUser() async {
    setState(() {
      isLoading = true;
    });
    var uzr = await AuthService().getThisUser();
    setState(() {
      isLoading = false;
    });
    if (uzr.error == null) {
      setState(() {
        _thisUser = uzr;
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
          'Mon compte',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().bgColor,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
        actions: [
          IconButton(
            tooltip: 'Changer mot de passe',
            icon: Icon(
              Icons.lock,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                CubePageRoute(
                  enterPage: ChangePasswordScreen(),
                  exitPage: ChangePasswordScreen(),
                  duration: const Duration(milliseconds: 300),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
          child: _thisUser != null
              ? Column(
                  children: [
                    UserProfilePicture(
                      avatar: widget.userObj.picture != null
                          ? widget.userObj.picture
                          : null,
                      width: 80,
                      height: 80,
                    ),
                    CustomCard(
                      color: MyColors().bgColor.withOpacity(0.2),
                      content: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Total gains',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 3),
                              Text(
                                '${NumberHelper().formatNumber(_thisUser.ewallet_total).toString()} F',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'Solde',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 3),
                              Text(
                                '${NumberHelper().formatNumber(_thisUser.ewallet_balance).toString()} F',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    CustomCard(
                      color: MyColors().bgColor.withOpacity(0.2),
                      content: Column(
                        children: [
                          CustomListVertical(
                            label: 'Nom et prénom(s)',
                            value:
                                _thisUser.firstName + ' ' + _thisUser.lastName,
                            valueIsBold: false,
                          ),
                          CustomListVertical(
                            label: 'Sexe et âge',
                            value:
                                '${_thisUser.sex == 'F' ? 'Féminin' : 'Masculin'}, ${_thisUser.age} ans',
                            valueIsBold: false,
                          ),
                          CustomHorizontalDiver(),
                          CustomListVertical(
                            label: 'Téléphone (username)',
                            value: _thisUser.phone.toString(),
                            valueIsBold: false,
                          ),
                          CustomHorizontalDiver(),
                          CustomListVertical(
                            label: 'Adresse email',
                            value: _thisUser.email,
                            valueIsBold: false,
                          ),
                          if (_thisUser.novaCashCore == true)
                            CustomHorizontalDiver(),
                          if (_thisUser.novaCashCore == true)
                            CustomListVertical(
                              label: 'Expiration',
                              value: DateHelper()
                                  .formatTimeStamp(_thisUser.expiry),
                              valueIsBold: false,
                            ),
                        ],
                      ),
                    ),
                  ],
                )
              : EmptyFolder(
                  isLoading: isLoading,
                  message: 'Un problème s\'est posé!',
                ),
        ),
      ),
    );
  }
}
