import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../../screens/account/team/filleuls.dart';
import '../../../widgets/common/empty_folder.dart';
import '../../../widgets/common/custom_flat_button_rounded.dart';
import '../../../widgets/common/custom_card.dart';
import '../../../widgets/common/custom_text_input.dart';
import '../../../models/user.dart';
import '../../../screens/auth/login.dart';
import '../../../services/user.dart';
import '../../../widgets/common/custom_alert.dart';
import '../../../styles/styles.dart';
import 'filleul_list.dart';

class MemberSearchScreen extends StatefulWidget {
  @override
  _MemberSearchScreenState createState() => _MemberSearchScreenState();
}

class _MemberSearchScreenState extends State<MemberSearchScreen> {
  List<UserModel> records;
  String _toSearch;
  bool isLoading = false;
  UserModel _thisUser;

  void _getRecords({String string}) async {
    if (_toSearch != null && _toSearch.length >= 5) {
      setState(() {
        isLoading = true;
      });
      var result = await AuthService().searchMember(toSearch: _toSearch);
      if (result != null && result[0].error != 'No data') {
        setState(() {
          isLoading = false;
          records = result;
        });
      } else {
        setState(() {
          isLoading = false;
          records = [];
        });
        CustomAlert(
          colorBg: Colors.white,
          colorText: Colors.black,
        ).alert(
          context,
          'Désolé!',
          result[0].error,
          true,
        );
      }
    } else {
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Attention!',
        'Entrez un nom ou un numéro de téléphone à chercher',
        true,
      );
    }
  }

  void _getUser() async {
    var uzr = await AuthService().getThisUser();
    if (uzr.error == null) {
      setState(() {
        _thisUser = uzr;
      });
      // do any other stuff here

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
          'Chercher un membre',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().bgColor,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(
              Icons.list,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                CubePageRoute(
                  enterPage: DownlineScreen(),
                  exitPage: DownlineScreen(),
                  duration: const Duration(milliseconds: 300),
                ),
              );
            },
            tooltip: 'Mes filleuls',
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
                  'assets/images/icon-filleuls.png',
                  //fit: BoxFit.cover,
                ),
                //decoration: BoxDecoration(color: Colors.green),
                height: 70,
                //width: double.infinity,
              ),
              SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.height - 420,
                child:
                    records != null && records.length > 0 && isLoading == false
                        ? ListView.builder(
                            itemBuilder: (ctx, index) {
                              return DownlineList(
                                filleul: records[index],
                                userKey: _thisUser.key,
                              );
                            },
                            itemCount: records.length,
                          )
                        : EmptyFolder(
                            isLoading: isLoading,
                            message:
                                'Entrez un nom, un mail ou un numéro à chercher',
                          ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CustomCard(
                  content: Column(
                    children: [
                      CustomTextInput(
                        isObscure: false,
                        maxLength: 50,
                        maxLines: 1,
                        inputType: TextInputType.text,
                        labelText: 'Qui cherchez-vous?',
                        helpText: 'Entrez NOM, TEL ou MAIL',
                        onChanged: (value) {
                          setState(() {
                            _toSearch = value;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: CustomFlatButtonRounded(
                          label: 'Chercher',
                          borderRadius: 50,
                          function: () {
                            _getRecords(string: _toSearch);
                          },
                          borderColor: Colors.transparent,
                          bgColor: MyColors().bgColor,
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
