import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '../../../models/reload.dart';
import '../../../models/user.dart';
import '../../../screens/auth/login.dart';
import '../../../services/reload.dart';
import '../../../services/user.dart';
import '../../../widgets/common/custom_alert.dart';
import '../../../widgets/common/empty_folder.dart';
import '../../../styles/styles.dart';
import '../../../helpers/common.dart';
import 'reload_choice.dart';
import 'reload_list.dart';

class ReloadsScreen extends StatefulWidget {
  @override
  _ReloadsScreenState createState() => _ReloadsScreenState();
}

class _ReloadsScreenState extends State<ReloadsScreen> {
  List<ReloadModel> records = [];

  int _selectedDate;
  bool isLoading = true;
  var toDay;
  var toMonth;
  var toYear;
  UserModel _thisUser;
  var _errMessage = 'Oops!';

  void _getRecords({String userKey, int month, int year}) async {
    setState(() {
      isLoading = true;
    });
    var result = await ReloadService()
        .myReloads(userKey: userKey, month: month, year: year);

    if (result != null && result[0].error != 'No data') {
      setState(() {
        isLoading = false;
        records = result;
      });
    } else {
      setState(() {
        isLoading = false;
        records = [];
        _errMessage =
            'Vous n\'avez effectué aucun dépôt au mois de ${DateHelper().formatTimeStampShort(_selectedDate)}';
      });
    }
  }

  void _openDatePicker() {
    showMonthPicker(
      context: context,
      locale: const Locale("fr", "FR"),
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
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
      _getRecords(userKey: uzr.key, month: toMonth, year: toYear);
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
              ? 'Mes dépôts'
              : DateHelper().formatTimeStamp(_selectedDate),
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().primary,
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
              Icons.add_circle,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).push(
                CubePageRoute(
                  enterPage: ReloadChoiceScreen(),
                  exitPage: ReloadChoiceScreen(),
                  duration: const Duration(milliseconds: 300),
                ),
              );
            },
            tooltip: 'Effectuer un dépôt',
          ),
        ],
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 10.0),
          child: Column(
            children: [
              Container(
                child: Image.asset(
                  'assets/images/icon-deposit.png',
                  //fit: BoxFit.cover,
                ),
                //decoration: BoxDecoration(color: Colors.green),
                height: 120,
                //width: double.infinity,
              ),
              Text('Cliquez sur l\'icône (+) pour effectuer un dépôt'),
              SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.height - 260,
                child: records.length > 0
                    ? ListView.builder(
                        itemBuilder: (ctx, index) {
                          return ReloadList(
                            status: records[index].status,
                            title: records[index].channel,
                            amount: records[index].amountXOF,
                            timeStamp: records[index].timeStamp,
                            channel: records[index].channel,
                            txid: records[index].txid,
                            amountCrypto: records[index].amountCrypto,
                            balanceAfter: records[index].balanceAfter,
                            balanceBefore: records[index].balanceBefore,
                          );
                        },
                        itemCount: records.length,
                      )
                    : EmptyFolder(
                        isLoading: isLoading,
                        message: _errMessage,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
