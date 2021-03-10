import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../../../models/user.dart';
import '../../../../widgets/common/empty_folder.dart';
import 'paris_list.dart';
import '../../../auth/login.dart';
import '../../../../services/jackpot.dart';
import '../../../../services/user.dart';
import '../../../../widgets/common/custom_alert.dart';
import '../../../../helpers/common.dart';
import '../../../../styles/styles.dart';
import '../../../../models/jackpot.dart';

class MesParisJackpotBasicScreen extends StatefulWidget {
  @override
  _MesParisJackpotBasicScreenState createState() =>
      _MesParisJackpotBasicScreenState();
}

class _MesParisJackpotBasicScreenState
    extends State<MesParisJackpotBasicScreen> {
  int _selectedDate;
  bool isLoading = true;
  UserModel thisUser;
  var toDay;
  var toMonth;
  var toYear;
  List<JackpotPlayModel> records = [];

  void _openDatePicker() {
    showDatePicker(
      context: context,
      locale: const Locale("fr", "FR"),
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
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
        });
        //print(DateTime.parse(value.toString()).millisecondsSinceEpoch);
        setState(() {
          _selectedDate = DateTime.parse(value.toString())
              .millisecondsSinceEpoch; // 1609718400000
          isLoading = true;
        });
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
    var results = await JackpotService().mesParis(
      userKey: userKey,
      day: day,
      month: month,
      year: year,
    );
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
              ? 'Mes Free Coins'
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
            tooltip: 'Filter',
          ),
        ],
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Image.asset(
                'assets/images/banner_jackpot.jpg',
                fit: BoxFit.cover,
              ),
              //decoration: BoxDecoration(color: Colors.green),
              height: 80,
              width: double.infinity,
            ),
            SizedBox(height: 5),
            //CustomLoadingIndicator(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                height: MediaQuery.of(context).size.height - 150,
                child: records.length > 0 && isLoading == false
                    ? ListView.builder(
                        itemBuilder: (ctx, index) {
                          return MesParisJackpotList(
                            pariObj: records[index],
                          );
                        },
                        itemCount: records.length,
                      )
                    : EmptyFolder(
                        isLoading: isLoading,
                        message:
                            'Vous n\'avez pas participé au Free Coins le ${DateHelper().formatTimeStamp(_selectedDate)}. Essayez une autre date en cliquant sur la loupe dans le coin haut droit de votre écran',
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
