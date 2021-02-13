import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../screens/account/transfert/transferts.dart';
import '../../screens/account/team/filleuls.dart';
import '../../screens/account/tutorial/tutorials.dart';
import '../../screens/admin/admin.dart';
import '../../screens/account/bonus/bonus.dart';
import '../../screens/account/expiration/renew.dart';
import '../../models/user.dart';
import '../../screens/account/withdraw/withdrawals.dart';
import '../../models/navigation.dart';
import '../../screens/account/reload/reloads.dart';
import '../../screens/account/user/profile.dart';
import 'drawer_list_item.dart';

class DrawerList extends StatelessWidget {
  final UserModel userObj;
  DrawerList({this.userObj});
  @override
  Widget build(BuildContext context) {
    final List<NavigationModel> menuObj = [
      NavigationModel(
        label: 'Mon compte',
        imageUrl: 'assets/images/icon-account.png',
        screen: ProfileScreen(userObj: userObj),
      ),
      NavigationModel(
        label: 'Se réabonner',
        imageUrl: 'assets/images/icon-premium.png',
        screen: ExpirRenewScreen(),
      ),
      NavigationModel(
        label: 'Dépôts',
        imageUrl: 'assets/images/icon-deposit.png',
        screen: ReloadsScreen(),
      ),
      NavigationModel(
        label: 'Retraits',
        imageUrl: 'assets/images/icon-withdraw.png',
        screen: WithdrawalsScreen(),
      ),
      NavigationModel(
        label: 'Transferts',
        imageUrl: 'assets/images/icon-transfert.png',
        screen: TransfertsScreen(),
      ),
      NavigationModel(
        label: 'Mes filleuls',
        imageUrl: 'assets/images/icon-affiliate.png',
        screen: DownlineScreen(),
      ),
      NavigationModel(
        label: 'Bonus',
        imageUrl: 'assets/images/icon-bonus.png',
        screen: BonusScreen(),
      ),
      NavigationModel(
        label: 'Tutoriels',
        imageUrl: 'assets/images/icon-tutorials.png',
        screen: TutorialScreen(),
      ),
      if (userObj.isSuperAdmin == true)
        NavigationModel(
          label: 'Manager',
          imageUrl: 'assets/images/icon-admin.png',
          screen: AdminHomeScreen(),
        ),
    ];

    void navigateToScreen({Widget screen}) {
      Navigator.of(context).pop();
      Navigator.of(context).push(
        CubePageRoute(
          enterPage: screen,
          exitPage: screen,
          duration: const Duration(milliseconds: 300),
        ),
      );
    }

    return Container(
      height: MediaQuery.of(context).size.height - 135,
      child: GridView.count(
        scrollDirection: Axis.vertical,
        crossAxisCount: 2,
        padding: EdgeInsets.all(15),
        childAspectRatio: 1.2,
        children: List.generate(menuObj.length, (index) {
          return DrawerListItem(
            label: menuObj[index].label,
            imageUrl: menuObj[index].imageUrl,
            screen: menuObj[index].screen,
            callBack: navigateToScreen,
          );
        }),
      ),
    );
  }
}
