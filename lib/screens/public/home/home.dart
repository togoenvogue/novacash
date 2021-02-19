import 'package:flutter/material.dart';
import 'package:easy_permission_validator/easy_permission_validator.dart';
import 'package:cube_transition/cube_transition.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';
import 'package:carousel_pro/carousel_pro.dart';

import '../../../widgets/home/home_static_button_list.dart';
import '../../../screens/public/static/upgrade.dart';
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
      });
      _getVersion();
      // get user permission
      _permissionWithCustomPopup();
    } else {
      // error
    }
  }

  void _getVersion() async {
    String platformVersion;
    if (app != null) {
      //print(app.app_ios_store);
      // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        //platformVersion = await GetVersion.appID; // dev.novalead.novabets
        //platformVersion = await GetVersion.appName; // NovaBets
        //platformVersion = await GetVersion.platformVersion; // iOS 14.4
        await GetVersion.platformVersion;

        platformVersion = await GetVersion.projectVersion; // iOS 14.4
        //print(platformVersion);
        if (platformVersion != app.version_current) {
          Navigator.of(context).pushReplacement(
            CubePageRoute(
              enterPage: UpgradeScreen(
                url: app.app_android_store,
                message: app.app_whats_new,
                oldVersion: app.version_previous,
                newVersion: app.version_current,
              ),
              exitPage: UpgradeScreen(
                url: app.app_android_store,
                message: app.app_whats_new,
                oldVersion: app.version_previous,
                newVersion: app.version_current,
              ),
              duration: const Duration(milliseconds: 300),
            ),
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Une combinaison du Crowdfunding et de le Marketing Digital',
                      style: TextStyle(
                        fontSize: 17,
                        color: Color(0xffc0edb4),
                        fontFamily: MyFontFamily().family2,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: Text(
                    'Promotions, réductions spéciales, ventes falsh, offres d\'emplois et de stages ... tout le monde y gagne!',
                    style: TextStyle(
                      fontSize: 12,
                      color: MyColors().white,
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
                SizedBox(
                  height: 250.0,
                  width: MediaQuery.of(context).size.width,
                  child: Carousel(
                    images: [
                      ExactAssetImage("assets/images/marketing-digital.jpg"),
                      ExactAssetImage("assets/images/happy_man.jpg"),
                      //NetworkImage('https://cdn-images-1.medium.com/max/2000/1*GqdzzfB_BHorv7V2NV7Jgg.jpeg'),
                      ExactAssetImage("assets/images/award1.jpg"),
                      ExactAssetImage("assets/images/award2.jpg"),
                      ExactAssetImage("assets/images/benz.jpg"),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                app != null
                    ? HomeStaticButtonList(app: app, userKey: null)
                    : Text(
                        '... chargement en cours',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  child: CustomFlatButtonRounded(
                    label: 'Connexion',
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
                    borderColor: Colors.transparent,
                    bgColor: Colors.green.withOpacity(0.3),
                    textColor: Colors.white,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  child: CustomFlatButtonRounded(
                    label: 'S\'inscrire',
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
                    borderColor: Colors.transparent,
                    bgColor: Colors.green.withOpacity(0.3),
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
