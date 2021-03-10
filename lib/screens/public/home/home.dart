import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';

import '../../auth/signup_choice.dart';
import '../../../widgets/common/home_carousel.dart';
import '../../../widgets/home/home_static_button_list.dart';
import '../../../screens/public/static/upgrade.dart';
import '../../../models/config.dart';
import '../../../services/config.dart';
import '../../../widgets/home/version.dart';
import '../../../widgets/common/custom_flat_button_rounded.dart';
import '../../../styles/styles.dart';
import '../../../widgets/common/logo.dart';
import '../../../screens/auth/login.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppConfigModel app;
  String appVersion;

  void _getConfigs() async {
    var result = await AppService().app();
    if (result != null && result.error == null) {
      setState(() {
        app = result;
      });
      _getVersion();
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
        //platformVersion = await GetVersion.appID; // dev.novalead.novacash
        //platformVersion = await GetVersion.appName; // NovaCash
        //platformVersion = await GetVersion.platformVersion; // iOS 14.4
        await GetVersion.platformVersion;

        platformVersion = await GetVersion.projectVersion; // iOS 14.4
        setState(() {
          appVersion = platformVersion;
        });
        //print('platformVersion: $platformVersion');
        //print('app.version_current: ${app.version_current}');
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
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Crowdfunding + Marketing Digital',
                      style: TextStyle(
                        fontSize: 17,
                        color: Color(0xffc0edb4),
                        fontFamily: MyFontFamily().family1,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: Text(
                    'Promotions, réductions, ventes flash, offres d\'emplois et de stages ... tout le monde y gagne!',
                    style: TextStyle(
                      fontSize: 12,
                      color: MyColors().white,
                      fontFamily: MyFontFamily().family1,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  height: 240.0,
                  width: MediaQuery.of(context).size.width,
                  child: HomeCarousel(),
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
                          enterPage: SignupChoice(),
                          exitPage: SignupChoice(),
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
                if (app != null && appVersion != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: AppVersion(
                      app: app,
                      internalVersion: appVersion,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
}
