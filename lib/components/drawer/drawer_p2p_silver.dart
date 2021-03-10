import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../screens/account/matrix_core/jackpot/play.dart';
import '../../screens/admin/tokens/tokens.dart';
import '../../screens/account/matrix_p2p_silver/team/filleuls.dart';
import '../../screens/account/matrix_p2p_silver/team/network.dart';
import '../../screens/account/matrix_p2p_silver/transaction/transactions.dart';
import '../../screens/account/user/channels.dart';
import '../../widgets/common/custom_flat_button_rounded.dart';
import '../../screens/auth/contract.dart';
import '../../screens/account/user/settings.dart';
import '../../screens/public/apn/apn.dart';
import '../../screens/admin/admin.dart';
import '../../models/user.dart';
import '../../screens/account/matrix_core/withdraw/withdrawals.dart';
import '../../models/navigation.dart';
import '../../screens/account/user/profile.dart';
import 'drawer_item.dart';

class DrawerP2PSilverList extends StatelessWidget {
  final UserModel userObj;
  DrawerP2PSilverList({this.userObj});
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
        label: 'Canaux',
        imageUrl: 'assets/images/icon-channels.png',
        screen: UserChannelsScreen(),
      ),
      NavigationModel(
        label: 'Free Coins',
        imageUrl: 'assets/images/icon-coins.png',
        screen: JackpotPlayScreen(),
      ),
      NavigationModel(
        label: 'Points focaux',
        imageUrl: 'assets/images/icon-location.png',
        screen: ApnScreen(),
      ),
      NavigationModel(
        label: 'Mes filleuls',
        imageUrl: 'assets/images/icon-filleuls.png',
        screen: P2PSilverDownlineScreen(),
      ),
      NavigationModel(
        label: 'Mon équipe',
        imageUrl: 'assets/images/icon-team.png',
        screen: P2PSilverMyNetworkScreen(),
      ),
      NavigationModel(
        label: 'Transactions',
        imageUrl: 'assets/images/icon-wallet.png',
        screen: P2PSilverTransactionsScreen(),
      ),
      NavigationModel(
        label: 'Retraits',
        imageUrl: 'assets/images/icon-withdraw.png',
        screen: WithdrawalsScreen(),
      ),
      NavigationModel(
        label: 'Tokens (Codes)',
        imageUrl: 'assets/images/icon-shield.png',
        screen: TokensScreen(),
      ),
      NavigationModel(
        label: 'CGU',
        imageUrl: 'assets/images/icon-cgu.png',
        screen: UserContractScreen(user: userObj),
      ),
      if (userObj.isSuperAdmin == true)
        NavigationModel(
          label: 'Manager',
          imageUrl: 'assets/images/icon-admin.png',
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
      child: userObj != null && userObj.novaCashP2PSilver == true
          ? GridView.count(
              scrollDirection: Axis.vertical,
              crossAxisCount: 2,
              padding: EdgeInsets.all(15),
              childAspectRatio: 1.5,
              children: List.generate(menuObj.length, (index) {
                return DrawerItem(
                  label: menuObj[index].label,
                  imageUrl: menuObj[index].imageUrl,
                  screen: menuObj[index].screen,
                  callBack: navigateToScreen,
                );
              }),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Text(
                    '''La matrice P2P SILVER dont l\'activation coûte 5 000 F (paiement unique) est basée sur le principe de ONE UP vous permettant de construire une équipe de 12 personnes et recevoir 35 000 F à vie
                    
Lisez le PDF pour plus de détails''',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  CustomFlatButtonRounded(
                    label: 'Activer P2P SILVER',
                    borderRadius: 50,
                    function: () {
                      Navigator.of(context).push(
                        CubePageRoute(
                          enterPage: UserChannelsScreen(),
                          exitPage: UserChannelsScreen(),
                          duration: const Duration(milliseconds: 300),
                        ),
                      );
                    },
                    borderColor: Colors.white,
                    bgColor: Colors.white,
                    textColor: Colors.black,
                  ),
                ],
              ),
            ),
    );
  }
}
