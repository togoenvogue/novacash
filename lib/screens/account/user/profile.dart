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
    // TODO: implement initState
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
        backgroundColor: MyColors().primary,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
        actions: [
          IconButton(
            tooltip: 'Changer mot de passe',
            icon: Icon(
              Icons.lock_open,
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
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(height: 10),
                    Text('Votre code d\'invitation est :'),
                    Text(
                      '${_thisUser.key}',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.redAccent,
                      ),
                    ),
                    CustomCard(
                      color: Color(0xffebffee),
                      content: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text('Solde dépôt'),
                              SizedBox(height: 3),
                              Text(
                                '${NumberHelper().formatNumber(_thisUser.credits_balance).toString()} FCFA',
                                style: TextStyle(
                                  color: MyColors().primary,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text('Solde retrait'),
                              SizedBox(height: 3),
                              Text(
                                '${NumberHelper().formatNumber(_thisUser.ewallet_balance).toString()} FCFA',
                                style: TextStyle(
                                  color: MyColors().primary,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    CustomCard(
                      content: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text('Total dépôt'),
                              SizedBox(height: 3),
                              Text(
                                '${NumberHelper().formatNumber(_thisUser.credits_total).toString()} FCFA',
                                style: TextStyle(
                                  color: MyColors().primary,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text('Total retrait'),
                              SizedBox(height: 3),
                              Text(
                                '${NumberHelper().formatNumber(_thisUser.ewallet_total).toString()} FCFA',
                                style: TextStyle(
                                  color: MyColors().primary,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    CustomCard(
                      content: Column(
                        children: [
                          CustomListVertical(
                            label: 'Vous êtes',
                            value:
                                _thisUser.firstName + ' ' + _thisUser.lastName,
                          ),
                          CustomHorizontalDiver(),
                          CustomListVertical(
                            label: 'Téléphone (username)',
                            value: _thisUser.phone.toString(),
                          ),
                          CustomHorizontalDiver(),
                          CustomListVertical(
                            label: 'Adresse email',
                            value: _thisUser.email,
                          ),
                          CustomHorizontalDiver(),
                          CustomListVertical(
                            label: 'Expiration',
                            value:
                                DateHelper().formatTimeStamp(_thisUser.expiry),
                          ),
                        ],
                      ),
                    ),
                    CustomCard(
                      color: Color(0xffebffee),
                      content: Column(
                        children: [
                          CustomListVertical(
                            label: 'Votre parrain',
                            value: _thisUser.sponsorKey['firstName'] +
                                ' ' +
                                _thisUser.sponsorKey['lastName'],
                          ),
                          CustomHorizontalDiver(),
                          CustomListVertical(
                            label: 'Téléphone (username)',
                            value: '+${_thisUser.sponsorKey['username']}',
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
