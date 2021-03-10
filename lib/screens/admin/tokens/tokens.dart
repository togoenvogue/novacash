import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../../screens/admin/tokens/token_create.dart';
import '../../../screens/admin/tokens/token_search.dart';
import '../../../models/token.dart';
import '../../../services/token.dart';
import '../../../models/user.dart';
import '../../../screens/auth/login.dart';
import '../../../services/user.dart';
import '../../../widgets/common/custom_alert.dart';
import '../../../widgets/common/empty_folder.dart';
import '../../../styles/styles.dart';
import '../../../helpers/common.dart';
import 'token_list.dart';

class TokensScreen extends StatefulWidget {
  @override
  _TokensScreenState createState() => _TokensScreenState();
}

class _TokensScreenState extends State<TokensScreen> {
  List<TokenModel> records = [];

  int _selectedDate;
  bool isLoading = true;
  var toDay;
  var toMonth;
  var toYear;
  UserModel _thisUser;
  var _errMessage = 'Oops!';

  void _getRecords(
      {String userKey, @required int day, int month, int year}) async {
    setState(() {
      isLoading = true;
    });
    var result = await TokenService()
        .adminTokens(adminKey: userKey, day: day, month: month, year: year);

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
            'Désolé, vous n\'avez généré aucun code de validation ce ${DateHelper().formatTimeStamp(_selectedDate)}';
      });
    }
  }

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
          _selectedDate = DateTime.parse(value.toString())
              .millisecondsSinceEpoch; // 1609718400000
        });
        _getRecords(
            userKey: _thisUser.key, day: toDay, month: toMonth, year: toYear);
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
      _getRecords(userKey: uzr.key, day: toDay, month: toMonth, year: toYear);
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
              ? 'Codes'
              : DateHelper().formatTimeStamp(_selectedDate),
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().bgColor,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(
              Icons.date_range,
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
              Icons.search,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                CubePageRoute(
                  enterPage: TokenSearchScreen(),
                  exitPage: TokenSearchScreen(),
                  duration: const Duration(milliseconds: 300),
                ),
              );
            },
            tooltip: 'Chercher un code',
          ),
          IconButton(
            icon: Icon(
              Icons.add_circle,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                CubePageRoute(
                  enterPage: TokenCreateScreen(),
                  exitPage: TokenCreateScreen(),
                  duration: const Duration(milliseconds: 300),
                ),
              );
            },
            tooltip: 'Générer des codes',
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
                  'assets/images/icon-shield.png',
                  //fit: BoxFit.cover,
                ),
                //decoration: BoxDecoration(color: Colors.green),
                height: 50,
                //width: double.infinity,
              ),
              _thisUser != null && _thisUser.isSupport
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Cliquez sur l\'icône (+) pour générer des Tokens (Codes) avec votre compte master',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Cliquez sur l\'icône (+) pour générer des Tokens (Codes) de validation avec vos gains',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
              SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.height - 250,
                child: records.length > 0 && isLoading == false
                    ? ListView.builder(
                        itemBuilder: (ctx, index) {
                          return TokenList(
                            token: records[index],
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
