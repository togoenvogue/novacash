import 'package:flutter/material.dart';
import 'package:easy_permission_validator/easy_permission_validator.dart';
import 'package:cube_transition/cube_transition.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/config.dart';
import '../../../services/config.dart';
import '../../../widgets/common/custom_alert.dart';
import '../../../widgets/home/version.dart';
import '../../../widgets/common/custom_flat_button_rounded.dart';
import '../../../styles/styles.dart';
import '../../../widgets/common/logo.dart';
import '../../../screens/auth/login.dart';
import '../../../screens/auth/signup_step1.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppConfigModel app;
  String url;

  _launchURL() async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _permissionWithCustomPopup() async {
    EasyPermissionValidator permissionValidator = EasyPermissionValidator(
      context: context,
      appName: '${app.name}',
    );
    await permissionValidator.phone().then((_callPermissionResult) {
      // print('_callPermissionResult: $_callPermissionResult');
      if (_callPermissionResult == false) {
        //if ('_callPermissionResult' == 'false') {
        CustomAlert(
          colorBg: Colors.white,
          colorText: MyColors().primary,
        ).alert(
          context,
          'Permissions',
          """Vous devez autoriser ${app.name} à accéder à certaines fonctionnalités de votre téléphone pour pouvoir l\'utiliser
          
Fermez l'application, puis relancez-la et accordez les permissions requises""",
          false,
        );
      }
    });
    // phone state
  }

  void _getConfigs() async {
    var result = await AppService().app();
    if (result != null && result.error == null) {
      setState(() {
        app = result;
        url = app.app_android_store;
      });
      _getVersion();
      /*
      var prefs = await SharedPreferences.getInstance();
      prefs.setString('app_company', result.company);
      prefs.setString('app_desc', result.desc);
      prefs.setString('app_email', result.email);
      prefs.setString('app_name', result.name);
      prefs.setString('app_phone1', result.phone1);
      prefs.setString('app_phone2', result.phone2);
      prefs.setString('app_version_current', result.version_current);
      prefs.setString('app_version_previous', result.version_previous);
      prefs.setString('app_website', result.website);
      prefs.setDouble('app_foot_cote', result.foot_cote);
      prefs.setInt('app_expiration_cost', result.expiration_cost);
      prefs.setInt('app_foot_base_amount', result.foot_base_amount);
      prefs.setInt('app_jackpot1_base_amount', result.jackpot1_base_amount);
      prefs.setInt('app_jackpot2_base_amount', result.jackpot2_base_amount);
      prefs.setInt('app_minimum_deposit', result.minimum_deposit);
      prefs.setInt('app_minimum_withdraw', result.minimum_withdraw);
      prefs.setInt('app_pmu_base_amount', result.pmu_base_amount);
      prefs.setInt('app_pmu_parisur_amount', result.pmu_parisur_amount);
      */
      // ask for permissions
      _permissionWithCustomPopup();
    } else {
      // error
    }
  }

  void _getVersion() async {
    String platformVersion;
    String platform;
    if (app != null) {
      //print(app.app_ios_store);
      // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        //platformVersion = await GetVersion.appID; // dev.novalead.novabets
        //platformVersion = await GetVersion.appName; // NovaBets
        //platformVersion = await GetVersion.platformVersion; // iOS 14.4
        platform = await GetVersion.platformVersion;

        platformVersion = await GetVersion.projectVersion; // iOS 14.4
        //print(platformVersion);

        if (platformVersion != app.version_current) {
          CustomAlert(
            colorBg: Colors.white,
            colorText: Colors.black,
            titleStyle: TextStyle(
              fontSize: 25,
            ),
          ).appUpdater(
            context: context,
            newVersion: 'v${app.version_current}',
            oldVersion: '${app.version_previous}',
            message: app.version_update_desc,
            fnc: _launchURL,
          );
        }
      } on PlatformException {
        platformVersion = 'Failed to get platform version.';
      }
      //print(platformVersion);
    }
  }

  @override
  void initState() {
    super.initState();
    _getConfigs();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: MyColors().bgColor,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Logo(),
                /*Text(
                  '#1 du pari en ligne en Afrique',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black.withOpacity(0.6),
                    fontFamily: MyFontFamily().family2,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),*/
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Text(
                    'Enfin l\'appli qu\'on attendait tous!',
                    style: TextStyle(
                      fontSize: 17,
                      color: MyColors().primary,
                      fontFamily: MyFontFamily().family2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: Text(
                    'Pariez et encaissez vos gains par Orange Money, Mobicash (Moov Money), Flooz, Bitcoin, Ethereum',
                    style: TextStyle(
                      fontSize: 12,
                      color: MyColors().normal,
                      fontFamily: MyFontFamily().family2,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                /*SizedBox(height: 5),
                Text(
                  'EN PARTENARIAT AVEC EDUCOACH BURKINA',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: MyFontFamily().family3,
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),*/
                SizedBox(height: 8),
                Text('ACCUEIL'),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  child: CustomFlatButtonRounded(
                    label: 'Membre? Connectez-vous',
                    borderRadius: 50,
                    function: () {
                      Navigator.of(context).push(
                        CubePageRoute(
                          enterPage: LoginScreen(),
                          exitPage: LoginScreen(),
                          duration: const Duration(milliseconds: 300),
                        ),
                      );
                    },
                    bgColor: MyColors().primary,
                    textColor: Colors.white,
                    //borderColor: MyColors().primary,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  child: CustomFlatButtonRounded(
                    label: 'Nouveau? Inscrivez-vous',
                    borderRadius: 50,
                    function: () {
                      Navigator.of(context).push(
                        CubePageRoute(
                          enterPage: SignUpStep1Screen(),
                          exitPage: SignUpStep1Screen(),
                          duration: const Duration(milliseconds: 300),
                        ),
                      );
                    },
                    bgColor: Colors.green.withOpacity(0.6),
                    textColor: Colors.white,
                    //borderColor: Colors.transparent,
                  ),
                ),
                SizedBox(height: 5),
                if (app != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: AppVersion(app: app),
                  ),
              ],
            ),
          ),
        ),
      );
}
