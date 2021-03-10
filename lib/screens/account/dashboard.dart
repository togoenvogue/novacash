import 'package:flutter/material.dart';
import 'package:blinking_text/blinking_text.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../services/p2p.dart';
import '../../widgets/common/home_carousel.dart';
import '../../widgets/home/home_static_button_list.dart';
import '../../models/config.dart';
import '../../services/config.dart';
import '../../helpers/common.dart';
import '../../screens/account/messages/inbox.dart';
import '../../widgets/common/custom_alert.dart';
import '../../styles/styles.dart';
import '../../widgets/common/logo.dart';
import '../../components/drawer/drawer.dart';
import '../../widgets/home/version.dart';
import '../../models/user.dart';
import '../../config/configuration.dart';
import '../../screens/public/home/home.dart';
import '../../services/user.dart';
import 'matrix_p2p_silver/transaction/approve.dart';
import 'matrix_p2p_silver/transaction/notify.dart';

class DashboardScreen extends StatefulWidget {
  final UserModel userObj;
  DashboardScreen({this.userObj});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  AppConfigModel app;
  bool isLoading = false;

  void _getPending() async {
    var result = await P2PService().p2pSilverLatestPending(
      userKey: widget.userObj.key,
    );
    if (result != null && result.error == null && result.key != null) {
      // redirect

      if (result.fromKey['_key'] == widget.userObj.key) {
        Navigator.of(context).pop();
        Navigator.of(context).push(
          CubePageRoute(
            enterPage: P2PTransactionNotifyScreen(don: result),
            exitPage: P2PTransactionNotifyScreen(don: result),
            duration: const Duration(milliseconds: 300),
          ),
        );
      } else {
        // approve
        Navigator.of(context).pop();
        Navigator.of(context).push(
          CubePageRoute(
            enterPage: P2PTransactionApproveScreen(don: result),
            exitPage: P2PTransactionApproveScreen(don: result),
            duration: const Duration(milliseconds: 300),
          ),
        );
      }
    }
  }

  void _getConfigs() async {
    var result = await AppService().app();
    if (result != null && result.error == null) {
      setState(() {
        app = result;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getConfigs();
    if (widget.userObj != null && widget.userObj.novaCashP2PSilver == true) {
      _getPending();
    }
  }

  @override
  Widget build(BuildContext context) {
    // logout
    void logout() async {
      setState(() {
        isLoading = true;
      });
      CustomAlert().loading(
        context: context,
        dismiss: false,
        isLoading: isLoading,
      );
      var result = await AuthService().logout(key: widget.userObj.key);
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
      if (result.error == null) {
        // bye bye sound
        CustomAlert(
          colorBg: Colors.white,
          colorText: Colors.black,
        ).alert(
          context,
          'Bye bye!',
          'Vous avez été déconnecté avec succès! A bientôt!',
          false,
        );
        // redirect
        await Future.delayed(const Duration(seconds: 5));
        Navigator.of(context).pop();
        //Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
          CubePageRoute(
            enterPage: HomeScreen(),
            exitPage: HomeScreen(),
            duration: const Duration(milliseconds: 300),
          ),
        );
      } else {
        CustomAlert(
          colorBg: Colors.white,
          colorText: Colors.black,
        ).alert(context, 'Oops!', result.error, true);
      }
    }

    return Scaffold(
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Color(0xFF178a66),
        ),
        child: Drawer(
          child: DrawerMain(userObj: widget.userObj),
        ),
      ),
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network(
              '$flagUrl/${widget.userObj.countryFlag.toLowerCase()}.png',
              height: 16,
            ),
            SizedBox(width: 9),
            Text(
              '+${widget.userObj.username}',
              style: TextStyle(
                color: Colors.white,
                fontFamily: MyFontFamily().family1,
                fontSize: 16,
              ),
            ),
          ],
        ),
        backgroundColor: MyColors().bgColor,
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 34,
        ),
        actions: [
          IconButton(
            tooltip: 'Se déconnecter',
            icon: Icon(
              Icons.power_settings_new,
              size: 30,
            ),
            onPressed: () {
              CustomAlert(
                colorBg: Colors.yellow,
                colorText: Colors.black.withOpacity(0.7),
                titleStyle: TextStyle(
                  fontFamily: MyFontFamily().family2,
                ),
              ).confirm(
                cancelFn: () {},
                confirmFn: logout,
                context: context,
                content: Text(
                  'Voulez-vous vraiment vous déconnecter?',
                  textAlign: TextAlign.center,
                ),
                submitText: 'Oui',
                cancelText: 'Non',
                title: 'Déconnexion',
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.notifications_active,
              //Icons.notifications_active,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).push(
                CubePageRoute(
                  enterPage: MessageInboxScreen(userKey: widget.userObj.key),
                  exitPage: MessageInboxScreen(userKey: widget.userObj.key),
                  duration: const Duration(milliseconds: 300),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Logo(),
              SizedBox(height: 10),
              Container(
                child: Text(
                  widget.userObj.firstName,
                  style: TextStyle(
                    fontSize: 18,
                    color: MyColors().primary,
                    fontFamily: MyFontFamily().family4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              widget.userObj.expiry > 0
                  ? Text(
                      'Expir: ${DateHelper().formatTimeStamp(widget.userObj.expiry)}',
                      style: TextStyle(
                        color: MyColors().success,
                        fontSize: 14,
                      ),
                    )
                  : BlinkText(
                      'Attention, votre compte a expiré!',
                      style: TextStyle(
                        color: MyColors().danger,
                        fontSize: 14,
                      ),
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
}
