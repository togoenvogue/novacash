import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import '../../../models/transfer.dart';
import '../../../services/transfert.dart';
import '../../../models/user.dart';
import '../../../screens/auth/login.dart';
import '../../../services/user.dart';
import '../../../widgets/common/custom_alert.dart';
import '../../../widgets/common/empty_folder.dart';
import '../../../styles/styles.dart';
import '../../../helpers/common.dart';
import 'transfert_list.dart';
import 'transfert_create.dart';

class TransfertsScreen extends StatefulWidget {
  @override
  _TransfertsScreenState createState() => _TransfertsScreenState();
}

class _TransfertsScreenState extends State<TransfertsScreen> {
  List<TransferModel> records = [];

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
    var result = await TransfertService()
        .transferts(userKey: userKey, month: month, year: year);

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
            'Vous n\'avez effectué aucun transfert au mois de ${DateHelper().formatTimeStampShort(_selectedDate)}';
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
              ? 'Transferts'
              : DateHelper().formatTimeStamp(_selectedDate),
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
              Icons.add_circle,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).push(
                CubePageRoute(
                  enterPage: TransfertCreateScreen(),
                  exitPage: TransfertCreateScreen(),
                  duration: const Duration(milliseconds: 300),
                ),
              );
            },
            tooltip: 'Effectuer un transfert',
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
                  'assets/images/icon-transfert.png',
                  //fit: BoxFit.cover,
                ),
                //decoration: BoxDecoration(color: Colors.green),
                height: 70,
                //width: double.infinity,
              ),
              Text(
                'Cliquez sur l\'icône (+) pour effectuer un transfert',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.height - 250,
                child: records.length > 0 && isLoading == false
                    ? ListView.builder(
                        itemBuilder: (ctx, index) {
                          return TransfertList(
                            transfer: records[index],
                            userKey: _thisUser.key,
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
