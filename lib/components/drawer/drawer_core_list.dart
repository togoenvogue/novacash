import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../screens/account/matrix_core/jackpot/play.dart';
import '../../screens/account/matrix_core/join/join_choice.dart';
import '../../widgets/common/custom_flat_button_rounded.dart';
import '../../screens/account/matrix_core/quiz/quiz.dart';
import '../../screens/admin/tokens/tokens.dart';
import '../../screens/auth/contract.dart';
import '../../screens/account/user/settings.dart';
import '../../screens/account/matrix_core/expiration/renew.dart';
import '../../screens/public/apn/apn.dart';
import '../../screens/account/matrix_core/award/award.dart';
import '../../screens/account/matrix_core/team/network.dart';
import '../../screens/account/matrix_core/transfert/transferts.dart';
import '../../screens/account/matrix_core/team/filleuls.dart';
import '../../screens/admin/admin.dart';
import '../../screens/account/matrix_core/bonus/bonus.dart';
import '../../models/user.dart';
import '../../screens/account/matrix_core/withdraw/withdrawals.dart';
import '../../models/navigation.dart';
import '../../screens/account/user/profile.dart';
import 'drawer_item.dart';

class DrawerCoreList extends StatelessWidget {
  final UserModel userObj;
  DrawerCoreList({this.userObj});
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
        label: 'Free Coins',
        imageUrl: 'assets/images/icon-coins.png',
        screen: JackpotPlayScreen(),
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
        label: 'Gains ou Bonus',
        imageUrl: 'assets/images/icon-bonus.png',
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
        label: 'Tokens (Codes)',
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
      child: userObj != null && userObj.novaCashCore == true
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
                    '''La matrice PREMIUM dont l\'activation coûte 7 000 FCFA par mois est basée sur une matrice binaire (avec débordement forcé) vous permettant de recevoir des bonus de 3 500 FCFA à l\'infini en profondeur dans votre matrice, puis un ANDROID, une MOTO et UNE VOITURE en un temps record.
                  
Lisez le PDF pour plus de détails''',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  CustomFlatButtonRounded(
                    label: 'Activer la matrice PREMIUM',
                    borderRadius: 50,
                    function: () {
                      Navigator.of(context).push(
                        CubePageRoute(
                          enterPage: MatrixCoreJoinChoice(
                            userKey: userObj.key,
                            username: userObj.username,
                          ),
                          exitPage: MatrixCoreJoinChoice(
                            userKey: userObj.key,
                            username: userObj.username,
                          ),
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
