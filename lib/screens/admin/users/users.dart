import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '../../../helpers/common.dart';
import '../../../screens/admin/users/users_list.dart';
import '../../../widgets/common/empty_folder.dart';
import '../../../models/user.dart';
import '../../../screens/auth/login.dart';
import '../../../services/user.dart';
import '../../../widgets/common/custom_alert.dart';
import '../../../styles/styles.dart';

class AdminUsersScreen extends StatefulWidget {
  @override
  _AdminUsersScreenState createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  List<UserModel> records = [];
  bool isLoading = false;
  UserModel _thisUser;
  var toDay;
  var toMonth;
  var toYear;
  int _selectedDate;

  void _openDatePicker() {
    showMonthPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
      locale: const Locale("fr", "FR"),
    ).then((value) {
      if (value == null) {
        return;
      } else {
        var year = value.toString().substring(0, 4);
        var month = value.toString().substring(5, 7);
        var day = value.toString().substring(8, 10);

        setState(() {
          toDay = int.parse(day);
          toMonth = int.parse(month);
          toYear = int.parse(year);
        });
        //print(DateTime.parse(value.toString()).millisecondsSinceEpoch);
        setState(() {
          _selectedDate = DateTime.parse(value.toString())
              .millisecondsSinceEpoch; // 1609718400000
        });
        // call
        _getRecords(month: toMonth, year: toYear);
      }
    });
  }

  void _getRecords({int month, int year}) async {
    setState(() {
      isLoading = true;
    });
    var downl = await AuthService().adminUsers(month: toMonth, year: toYear);
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
      _getRecords(month: toMonth, year: toYear);
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
    var date = new DateTime.now();
    var year = date.toString().substring(0, 4);
    var month = date.toString().substring(5, 7);
    var day = date.toString().substring(8, 10);
    setState(() {
      _selectedDate = DateTime.now().millisecondsSinceEpoch;
      toDay = int.parse(day);
      toMonth = int.parse(month);
      toYear = int.parse(year);
    });
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              _openDatePicker();
            },
            tooltip: 'Filtrer',
          ),
        ],
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
                              message:
                                  'Aucun inscrit au mois de ${DateHelper().formatTimeStampShort(_selectedDate)}',
                            ),
                    ),
                  ],
                )
              : EmptyFolder(
                  isLoading: isLoading,
                  message:
                      'Aucun inscrit au mois de ${DateHelper().formatTimeStampShort(_selectedDate)}',
                ),
        ),
      ),
    );
  }
}
