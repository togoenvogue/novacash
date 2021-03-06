import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';
import 'package:platform_device_id/platform_device_id.dart';

import '../../screens/admin/users/apn.dart';
import '../../screens/admin/users/users.dart';
import '../../models/user.dart';
import '../../screens/admin/withdrawals/withdrawals.dart';
import '../../widgets/common/custom_flat_button_rounded.dart';
import '../../models/config.dart';
import '../../styles/styles.dart';

class AdminHomeScreen extends StatefulWidget {
  final UserModel user;
  AdminHomeScreen({this.user});
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  AppConfigModel app;

  var _deviceId;

  void _getDeviceId() async {
    var result = await PlatformDeviceId.getDeviceId;
    setState(() {
      _deviceId = result;
    });
  }

  @override
  void initState() {
    super.initState();
    _getDeviceId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Administration',
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
              SelectableText(
                '$_deviceId',
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              CustomFlatButtonRounded(
                label: 'Liste des utilisateurs',
                borderRadius: 50,
                function: () {
                  Navigator.of(context).push(
                    CubePageRoute(
                      enterPage: AdminUsersScreen(),
                      exitPage: AdminUsersScreen(),
                      duration: const Duration(milliseconds: 300),
                    ),
                  );
                },
                borderColor: Colors.transparent,
                bgColor: Colors.green.withOpacity(0.6),
                textColor: Colors.white,
              ),
              CustomFlatButtonRounded(
                label: 'Demandes de retrait',
                borderRadius: 50,
                function: () {
                  Navigator.of(context).push(
                    CubePageRoute(
                      enterPage: AdminWithdrawalsScreen(),
                      exitPage: AdminWithdrawalsScreen(),
                      duration: const Duration(milliseconds: 300),
                    ),
                  );
                },
                borderColor: Colors.transparent,
                bgColor: Colors.green.withOpacity(0.6),
                textColor: Colors.white,
              ),
              CustomFlatButtonRounded(
                label: 'Points focaux',
                borderRadius: 50,
                function: () {
                  Navigator.of(context).push(
                    CubePageRoute(
                      enterPage: AdminApnScreen(),
                      exitPage: AdminApnScreen(),
                      duration: const Duration(milliseconds: 300),
                    ),
                  );
                },
                borderColor: Colors.transparent,
                bgColor: Colors.green.withOpacity(0.6),
                textColor: Colors.white,
              ),
              CustomFlatButtonRounded(
                label: 'Awards',
                borderRadius: 50,
                function: () {
                  Navigator.of(context).push(
                    CubePageRoute(
                      enterPage: AdminWithdrawalsScreen(),
                      exitPage: AdminWithdrawalsScreen(),
                      duration: const Duration(milliseconds: 300),
                    ),
                  );
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
