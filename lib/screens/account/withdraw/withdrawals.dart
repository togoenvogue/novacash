import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '../../../models/user.dart';
import '../../../screens/auth/login.dart';
import '../../../services/user.dart';
import '../../../services/withdraw.dart';
import '../../../widgets/common/custom_alert.dart';
import '../../../widgets/common/empty_folder.dart';
import '../../../models/withdrawal.dart';
import '../../../styles/styles.dart';
import '../../../helpers/common.dart';
import 'withdrawal_add.dart';
import 'withdrawals_list.dart';

class WithdrawalsScreen extends StatefulWidget {
  @override
  _WithdrawalsScreenState createState() => _WithdrawalsScreenState();
}

class _WithdrawalsScreenState extends State<WithdrawalsScreen> {
  int _selectedDate;
  //final dynamic _minimumWithdraw = 1000;
  UserModel thisUser;
  var toDay;
  var toMonth;
  var toYear;
  bool isLoading = true;
  List<WithdrawalModel> records = [];

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
        _getRecords(
          day: toDay,
          month: toMonth,
          year: toYear,
          userKey: thisUser.key,
        );
      }
    });
  }

  void _getRecords({String userKey, int day, int month, int year}) async {
    setState(() {
      isLoading = true;
    });

    var results = await WithdrawService()
        .myWithdrawals(month: toMonth, year: toYear, userKey: thisUser.key);
    setState(() {
      isLoading = false;
    });
    if (results != null &&
        results.length > 0 &&
        results[0].error != 'No data') {
      setState(() {
        records = results;
      });
    } else {
      setState(() {
        records = [];
      });
    }
  }

  void _getUser() async {
    var uzr = await AuthService().getThisUser();
    if (uzr.error == null) {
      thisUser = uzr;
      //print(thisUser.credits_balance);
      // if user is successfully retreived, then get the game
      _getRecords(
        userKey: thisUser.key,
        day: toDay,
        month: toMonth,
        year: toYear,
      );
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
      Navigator.of(context).pop();
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
              ? 'Mes retraits'
              : DateHelper().formatTimeStampShort(_selectedDate),
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
          IconButton(
            icon: Icon(
              Icons.add_circle_rounded,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                CubePageRoute(
                  enterPage: WithdrawalAddScreen(),
                  exitPage: WithdrawalAddScreen(),
                  duration: const Duration(milliseconds: 300),
                ),
              );
            },
            tooltip: 'Lancer un retrait',
          ),
        ],
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Image.asset(
                'assets/images/icon-withdraw.png',
                //fit: BoxFit.cover,
              ),
              //decoration: BoxDecoration(color: Colors.green),
              height: 70,
              //width: double.infinity,
            ),
            SizedBox(height: 5),
            Container(
              height: MediaQuery.of(context).size.height - 95,
              child: records != null && records.length > 0
                  ? ListView.builder(
                      itemBuilder: (ctx, index) {
                        return WithdrawalsList(
                          obj: records[index],
                        );
                      },
                      itemCount: records.length,
                    )
                  : EmptyFolder(
                      isLoading: isLoading,
                      message:
                          'Vous n\'avez effectué aucun retrait au mois de ${DateHelper().formatTimeStampShort(_selectedDate)}',
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
