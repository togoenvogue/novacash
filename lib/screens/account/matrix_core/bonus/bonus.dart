import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '../../../../helpers/common.dart';
import '../../../../models/bonus.dart';
import '../../../../models/user.dart';
import 'bonus_list.dart';
import '../../../../services/bonus.dart';
import '../../../../services/user.dart';
import '../../../../widgets/common/empty_folder.dart';
import '../../../../screens/auth/login.dart';
import '../../../../widgets/common/custom_alert.dart';
import '../../../../styles/styles.dart';

class BonusScreen extends StatefulWidget {
  @override
  _BonusScreenState createState() => _BonusScreenState();
}

class _BonusScreenState extends State<BonusScreen> {
  bool isLoading = true;
  int _selectedDate;
  var toDay;
  var toMonth;
  var toYear;
  List<BonusModel> records = [];
  UserModel _thisUser;

  void _getRecords({String userKey, int month, int year}) async {
    setState(() {
      isLoading = true;
      records = [];
    });
    var result = await BonusService()
        .myBonuses(month: month, year: year, userKey: userKey);
    setState(() {
      isLoading = false;
    });
    if (result != null && result[0].error != 'No data') {
      setState(() {
        records = result;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        records = [];
      });
    }
  }

  void _openDatePicker() {
    showMonthPicker(
      context: context,
      locale: const Locale("fr", "FR"),
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((value) {
      //print(value);
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
          _selectedDate = DateTime.parse(value.toString())
              .millisecondsSinceEpoch; // 1609718400000
        });
        _getRecords(userKey: _thisUser.key, month: toMonth, year: toYear);
        //print(DateTime.parse(value.toString()).millisecondsSinceEpoch);
      }
    });
  }

  void _getUser() async {
    var uzr = await AuthService().getThisUser();
    if (uzr.error == null) {
      setState(() {
        _thisUser = uzr;
      });
      // do any other stuff here
      _getRecords(month: toMonth, year: toYear, userKey: uzr.key);
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
          _selectedDate == null
              ? 'Mes gains'
              : 'Mes gains : ${DateHelper().formatTimeStampShort(_selectedDate)}',
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
            tooltip: 'Filter',
          ),
        ],
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10.0),
          child: Column(
            children: [
              Container(
                child: Image.asset(
                  'assets/images/icon-bonus.png',
                  //fit: BoxFit.cover,
                ),
                //decoration: BoxDecoration(color: Colors.green),
                height: 50,
                //width: double.infinity,
              ),
              Container(
                height: MediaQuery.of(context).size.height - 220,
                child: records.length > 0 && isLoading == false
                    ? ListView.builder(
                        itemBuilder: (ctx, index) {
                          return BonusList(bonus: records[index]);
                        },
                        itemCount: records.length,
                      )
                    : EmptyFolder(
                        isLoading: isLoading,
                        message:
                            'Vous n\'avez reçu aucun gain au mois de ${DateHelper().formatTimeStampShort(_selectedDate)}',
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
