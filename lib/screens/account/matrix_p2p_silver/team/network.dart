import 'package:flutter/material.dart';
import 'package:custom_radio_grouped_button/CustomButtons/ButtonTextStyle.dart';
import 'package:custom_radio_grouped_button/CustomButtons/CustomRadioButton.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../../../models/matrix_p2p.dart';
import '../../../../services/p2p.dart';
import '../../../../widgets/common/empty_folder.dart';
import '../../../../models/user.dart';
import '../../../../screens/auth/login.dart';
import '../../../../services/user.dart';
import '../../../../widgets/common/custom_alert.dart';
import '../../../../styles/styles.dart';
import 'filleul_list.dart';

class P2PSilverMyNetworkScreen extends StatefulWidget {
  @override
  _P2PSilverMyNetworkScreenState createState() =>
      _P2PSilverMyNetworkScreenState();
}

class _P2PSilverMyNetworkScreenState extends State<P2PSilverMyNetworkScreen> {
  List<MatrixP2PModel> records = [];
  bool isLoading = false;
  UserModel _thisUser;
  int _level = 1;
  int _levelCount = 2;

  void _getRecords({String userKey, int level}) async {
    setState(() {
      isLoading = true;
    });
    var downl = await P2PService().p2pMyNetwork(userKey: userKey, level: level);
    setState(() {
      isLoading = false;
    });
    if (downl != null && downl[0].error != 'No data') {
      setState(() {
        records = downl;
      });
    } else {
      setState(() {
        records = [];
      });
    }
  }

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
      _getRecords(userKey: uzr.key, level: _level);
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

  void _selectedLevel(int level) {
    setState(() {
      _level = level;
      if (level == 1) {
        _levelCount = 3;
      } else if (level == 2) {
        _levelCount = 9;
      }
    });
    _getRecords(level: _level, userKey: _thisUser.key);
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
          records == null && records.length == 0
              ? 'Mon reseau'
              : 'Niveau $_level (${records.length}/$_levelCount)',
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
              CustomRadioButton(
                buttonLables: ['Niveau 1', 'Niveau 2'],
                buttonValues: ['1', '2'],
                radioButtonValue: (value) {
                  _selectedLevel(int.parse(value));
                },
                defaultSelected: '1',
                unSelectedColor: Colors.white.withOpacity(0.6),
                selectedColor: Colors.green.withOpacity(0.8),
                selectedBorderColor: Colors.transparent,
                unSelectedBorderColor: Colors.transparent,
                enableShape: true,
                enableButtonWrap: true,
                buttonTextStyle: ButtonTextStyle(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontFamily: MyFontFamily().family1,
                  ),
                ),
                width: 110,
                elevation: 0,
              ),
              records.length > 0 && isLoading == false
                  ? Container(
                      height: MediaQuery.of(context).size.height - 190,
                      child: records != null &&
                              records.length > 0 &&
                              isLoading == false &&
                              _level > 0
                          ? ListView.builder(
                              itemBuilder: (ctx, index) {
                                return P2PSilverDownlineList(
                                  filleul: records[index],
                                  userKey: _thisUser.key,
                                );
                              },
                              itemCount: records.length,
                            )
                          : EmptyFolder(
                              isLoading: isLoading,
                            ),
                    )
                  : EmptyFolder(
                      isLoading: isLoading,
                      message:
                          'Vous ne disposez d\'aucun membre sur le niveau $_level',
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
