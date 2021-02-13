import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../../widgets/common/empty_folder.dart';
import '../../../models/user.dart';
import '../../../screens/account/team/filleul_list.dart';
import '../../../screens/auth/login.dart';
import '../../../services/user.dart';
import '../../../widgets/common/custom_alert.dart';
import '../../../styles/styles.dart';

class DownlineScreen extends StatefulWidget {
  @override
  _DownlineScreenState createState() => _DownlineScreenState();
}

class _DownlineScreenState extends State<DownlineScreen> {
  List<UserModel> records = [];
  bool isLoading = false;

  void _getRecords({String userKey}) async {
    setState(() {
      isLoading = true;
    });
    var downl = await AuthService().myDownlines(userKey: userKey);
    setState(() {
      isLoading = false;
    });
    if (downl != null && downl[0].error != 'No data') {
      setState(() {
        records = downl;
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
    // TODO: implement initState
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mes filleuls',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().primary,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: records.length > 0 && isLoading == false
              ? Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height - 100,
                      child: ListView.builder(
                        itemBuilder: (ctx, index) {
                          return DownlineList(filleul: records[index]);
                        },
                        itemCount: records.length,
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
