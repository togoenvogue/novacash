import 'package:flutter/material.dart';
import 'package:custom_radio_grouped_button/CustomButtons/ButtonTextStyle.dart';
import 'package:custom_radio_grouped_button/CustomButtons/CustomRadioButton.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../../../models/maxtix_core.dart';
import 'search.dart';
import '../../../../widgets/common/empty_folder.dart';
import '../../../../models/user.dart';
import 'filleul_list.dart';
import '../../../../screens/auth/login.dart';
import '../../../../services/user.dart';
import '../../../../widgets/common/custom_alert.dart';
import '../../../../styles/styles.dart';

class MyNetworkScreen extends StatefulWidget {
  @override
  _MyNetworkScreenState createState() => _MyNetworkScreenState();
}

class _MyNetworkScreenState extends State<MyNetworkScreen> {
  List<MatrixCoreModel> records = [];
  bool isLoading = false;
  UserModel _thisUser;
  int _level = 1;
  int _levelCount = 2;

  void _getRecords({String userKey, int level}) async {
    setState(() {
      isLoading = true;
    });
    var downl = await AuthService().myNetwork(userKey: userKey, level: level);
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
        _levelCount = 2;
      } else if (level == 2) {
        _levelCount = 4;
      } else if (level == 3) {
        _levelCount = 8;
      } else if (level == 4) {
        _levelCount = 16;
      } else if (level == 5) {
        _levelCount = 32;
      } else if (level == 6) {
        _levelCount = 64;
      } else if (level == 7) {
        _levelCount = 128;
      } else if (level == 8) {
        _levelCount = 256;
      } else if (level == 9) {
        _levelCount = 512;
      } else if (level == 10) {
        _levelCount = 1024;
      } else if (level == 11) {
        _levelCount = 2048;
      } else if (level == 12) {
        _levelCount = 4096;
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                CubePageRoute(
                  enterPage: MemberSearchScreen(),
                  exitPage: MemberSearchScreen(),
                  duration: const Duration(milliseconds: 300),
                ),
              );
            },
            tooltip: 'Chercher un membre',
          ),
        ],
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            children: [
              CustomRadioButton(
                buttonLables: [
                  '1',
                  '2',
                  '3',
                  '4',
                  '5',
                  '6',
                  '7',
                  '8',
                  '9',
                  '10',
                  '11',
                  '12'
                ],
                buttonValues: [
                  '1',
                  '2',
                  '3',
                  '4',
                  '5',
                  '6',
                  '7',
                  '8',
                  '9',
                  '10',
                  '11',
                  '12'
                ],
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
                width: 50,
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
                                return DownlineList(
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
