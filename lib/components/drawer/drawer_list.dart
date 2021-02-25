import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../screens/quiz/quiz.dart';
import '../../screens/admin/tokens/tokens.dart';
import '../../screens/auth/contract.dart';
import '../../screens/account/user/settings.dart';
import '../../screens/account/expiration/renew.dart';
import '../../screens/public/apn/apn.dart';
import '../../screens/account/award/award.dart';
import '../../screens/account/team/network.dart';
import '../../screens/account/transfert/transferts.dart';
import '../../screens/account/team/filleuls.dart';
import '../../screens/admin/admin.dart';
import '../../screens/account/bonus/bonus.dart';
import '../../models/user.dart';
import '../../screens/account/withdraw/withdrawals.dart';
import '../../models/navigation.dart';
import '../../screens/account/user/profile.dart';
import 'drawer_list_item.dart';

class DrawerList extends StatelessWidget {
  final UserModel userObj;
  DrawerList({this.userObj});
  @override
  Widget build(BuildContext context) {
    final List<NavigationModel> menuObj = [
      NavigationModel(
        label: 'Mon profil',
        imageUrl: 'assets/images/icon-account.png',
        screen: ProfileScreen(userObj: userObj),
      ),
      NavigationModel(
        label: 'Préférences',
        imageUrl: 'assets/images/icon-settings.png',
        screen: UserSettingsScreen(),
      ),
      NavigationModel(
        label: 'Nova Quiz',
        imageUrl: 'assets/images/icon-quiz.png',
        screen: QuizScreen(),
      ),
      NavigationModel(
        label: 'Autoship',
        imageUrl: 'assets/images/icon-autoship.png',
        screen: ExpirRenewScreen(),
      ),
      NavigationModel(
        label: 'Points focaux',
        imageUrl: 'assets/images/icon-location.png',
        screen: ApnScreen(),
      ),
      NavigationModel(
        label: 'Mes filleuls',
        imageUrl: 'assets/images/icon-filleuls.png',
        screen: DownlineScreen(),
      ),
      NavigationModel(
        label: 'Mon équipe',
        imageUrl: 'assets/images/icon-team.png',
        screen: MyNetworkScreen(),
      ),
      NavigationModel(
        label: 'Mes gains',
        imageUrl: 'assets/images/icon-wallet.png',
        screen: BonusScreen(),
      ),
      NavigationModel(
        label: 'Retraits',
        imageUrl: 'assets/images/icon-withdraw.png',
        screen: WithdrawalsScreen(),
      ),
      NavigationModel(
        label: 'Awards',
        imageUrl: 'assets/images/icon-award.png',
        screen: AwardsScreen(),
      ),
      NavigationModel(
        label: 'Transferts',
        imageUrl: 'assets/images/icon-transfert.png',
        screen: TransfertsScreen(),
      ),
      NavigationModel(
        label: 'Codes',
        imageUrl: 'assets/images/icon-shield.png',
        screen: TokensScreen(),
      ),
      NavigationModel(
        label: 'CGU',
        imageUrl: 'assets/images/icon-contract.png',
        screen: UserContractScreen(user: userObj),
      ),
      if (userObj.isSuperAdmin == true)
        NavigationModel(
          label: 'Manager',
          imageUrl: 'assets/images/icon-shield.png',
          screen: AdminHomeScreen(user: userObj),
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
