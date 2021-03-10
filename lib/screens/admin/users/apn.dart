import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';
import '../../../screens/admin/users/users_list.dart';
import '../../../widgets/common/empty_folder.dart';
import '../../../models/user.dart';
import '../../../screens/auth/login.dart';
import '../../../services/user.dart';
import '../../../widgets/common/custom_alert.dart';
import '../../../styles/styles.dart';

class AdminApnScreen extends StatefulWidget {
  @override
  _AdminApnScreenState createState() => _AdminApnScreenState();
}

class _AdminApnScreenState extends State<AdminApnScreen> {
  List<UserModel> records = [];
  bool isLoading = false;
  UserModel _thisUser;

  void _getRecords() async {
    setState(() {
      isLoading = true;
    });
    var downl = await AuthService().adminApns();
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
      _getRecords();
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
          'Liste des inscrits',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().bgColor,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10.0),
          child: records != null && records.length > 0 && isLoading == false
              ? Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height - 100,
                      child: records != null &&
                              records.length > 0 &&
                              isLoading == false
                          ? ListView.builder(
                              itemBuilder: (ctx, index) {
                                return AdminUsersList(
                                  filleul: records[index],
                                  userKey: _thisUser.key,
                                );
                              },
                              itemCount: records.length,
                            )
                          : EmptyFolder(
                              isLoading: isLoading,
                              message: 'Aucun point focal trouvé',
                            ),
                    ),
                  ],
                )
              : EmptyFolder(
                  isLoading: isLoading,
                  message: 'Aucun point focal trouvé',
                ),
        ),
      ),
    );
  }
}
