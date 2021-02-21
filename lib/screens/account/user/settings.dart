import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../../screens/account/dashboard.dart';
import '../../../services/user.dart';
import '../../../widgets/common/custom_alert.dart';
import '../../../screens/account/user/settings_list.dart';
import '../../../widgets/common/custom_flat_button_rounded.dart';
import '../../../models/user.dart';
import '../../../widgets/common/empty_folder.dart';
import '../../../models/category.dart';
import '../../../services/category.dart';
import '../../../styles/styles.dart';

class UserSettingsScreen extends StatefulWidget {
  final UserModel user;
  UserSettingsScreen({this.user});
  @override
  _UserSettingsScreenState createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  List<CategoryModel> records = [];
  bool isLoading = false;

  List<String> categs = [];

  void _getCategories() async {
    setState(() {
      isLoading = true;
    });

    var result = await CategoryService().getCategories();
    setState(() {
      isLoading = false;
    });

    if (result != null && result[0].error != 'No data') {
      setState(() {
        records = result;
      });
    } else {
      setState(() {
        records = [];
      });
    }
  }

  void _selectedCategory({bool isSelected, String categoryKey}) {
    // check if selectd id is found in the list
    bool found = categs.contains((categoryKey));
    if (found) {
      if (!isSelected) {
        categs.remove(categoryKey);
      } else {
        categs.add(categoryKey);
      }
    } else {
      if (isSelected) {
        categs.add(categoryKey);
      }
    }
  }

  void _submit() async {
    if (categs != null && categs.length >= 3) {
      setState(() {
        isLoading = true;
      });
      CustomAlert()
          .loading(context: context, dismiss: false, isLoading: isLoading);
      var result = await AuthService().setUserCategories(
        categories: categs,
        userKey: widget.user.key,
      );
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();

      if (result != null && result.error == null) {
        CustomAlert(
          colorBg: Colors.white,
          colorText: Colors.black,
        ).alert(
          context,
          'Succès!',
          'Vos préférences ont été enregistrées avec succès',
          false,
        );
        await Future.delayed(const Duration(seconds: 5));
        Navigator.of(context).pop();
        // redirect to login
        Navigator.of(context).pushReplacement(
          CubePageRoute(
            enterPage: DashboardScreen(userObj: result),
            exitPage: DashboardScreen(userObj: result),
            duration: const Duration(milliseconds: 300),
          ),
        );
      } else {
        CustomAlert(
          colorBg: Colors.white,
          colorText: Colors.black,
        ).alert(
          context,
          'Oops!',
          result.error,
          true,
        );
      }
    } else {
      // alert, select at least 3 categrories
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Attention!',
        'Vous devez sélectionner au moins 3 catégories',
        true,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Préférences',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().bgColor,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Image.asset(
                  'assets/images/icon-settings.png',
                ),
                height: 70,
              ),
              SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Vous devez sélectionner 3 domaines minimum dont vous souhaitez recevoir des alertes (notifications mail ou SMS)',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context).size.height - 320,
                child:
                    records != null && records.length > 0 && isLoading == false
                        ? ListView.builder(
                            itemBuilder: (ctx, index) {
                              return UserSettingsList(
                                category: records[index],
                                callBack: _selectedCategory,
                              );
                            },
                            itemCount: records.length,
                          )
                        : EmptyFolder(isLoading: isLoading),
              ),
              SizedBox(height: 10),
              CustomFlatButtonRounded(
                label: 'Enregistrer',
                borderRadius: 50,
                function: () {
                  _submit();
                },
                borderColor: Colors.transparent,
                bgColor: Colors.green.withOpacity(0.6),
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
