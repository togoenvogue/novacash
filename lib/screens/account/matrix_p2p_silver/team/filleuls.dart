import 'package:flutter/material.dart';
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

class P2PSilverDownlineScreen extends StatefulWidget {
  @override
  _P2PSilverDownlineScreenState createState() =>
      _P2PSilverDownlineScreenState();
}

class _P2PSilverDownlineScreenState extends State<P2PSilverDownlineScreen> {
  List<MatrixP2PModel> records = [];
  bool isLoading = false;
  UserModel _thisUser;

  void _getRecords({String userKey}) async {
    setState(() {
      isLoading = true;
    });
    var downl = await P2PService().p2pMyDownlines(userKey: _thisUser.key);
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
      _getRecords(userKey: uzr.key);
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
          'Mes filleuls P2P-SILVER',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().bgColor,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
          child: records.length > 0 && isLoading == false
              ? Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height - 100,
                      child: records != null &&
                              records.length > 0 &&
                              isLoading == false
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
                              message:
                                  'Vous n\'avez inscrit personne pour le moment',
                            ),
                    ),
                  ],
                )
              : EmptyFolder(
                  isLoading: isLoading,
                  message: 'Vous ne disposez d\'aucun filleul'),
        ),
      ),
    );
  }
}
