import 'package:flutter/material.dart';
import '../../../helpers/common.dart';
import '../../../widgets/common/custom_horizontal_diver.dart';
import '../../../widgets/common/custom_list_space_between.dart';
import '../../../models/user.dart';

class AdminUserDetail extends StatelessWidget {
  final UserModel user;
  AdminUserDetail({this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Column(
          children: [
            Text(
              '${user.firstName} ${user.lastName}',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              DateHelper().formatTimeStampFull(user.timeStamp),
              style: TextStyle(
                  fontSize: 14, color: Colors.redAccent.withOpacity(0.8)),
              textAlign: TextAlign.center,
            ),
            CustomListSpaceBetwen(
              label: 'Pays',
              value: '${user.countryName}',
            ),
            CustomHorizontalDiver(),
            CustomListSpaceBetwen(
              label: 'Téléphone',
              value: '+${user.username}',
            ),
            CustomHorizontalDiver(),
            CustomListSpaceBetwen(
              label: 'Email',
              value: '${user.email}',
            ),
            CustomHorizontalDiver(),
            CustomListSpaceBetwen(
              label: 'Expir',
              value: '${DateHelper().formatTimeStampFull(user.expiry)}',
            ),
            CustomHorizontalDiver(),
            CustomListSpaceBetwen(
              label: 'Ewallet total',
              value: '${NumberHelper().formatNumber(user.ewallet_total)} FCFA',
            ),
            CustomHorizontalDiver(),
            CustomListSpaceBetwen(
              label: 'Ewallet balance',
              value:
                  '${NumberHelper().formatNumber(user.ewallet_balance)} FCFA',
            ),
            if (user.isSupport != null && user.isSupport == true)
              CustomHorizontalDiver(),
            if (user.isSupport != null && user.isSupport == true)
              CustomListSpaceBetwen(
                label: 'Crédit total',
                value:
                    '${NumberHelper().formatNumber(user.credits_total)} FCFA',
                valueColor: Colors.red,
              ),
            if (user.isSupport != null && user.isSupport == true)
              CustomHorizontalDiver(),
            if (user.isSupport != null && user.isSupport == true)
              CustomListSpaceBetwen(
                label: 'Crédit balance',
                value:
                    '${NumberHelper().formatNumber(user.credits_balance)} FCFA',
                valueColor: Colors.red,
              ),
            CustomHorizontalDiver(),
            CustomListSpaceBetwen(
              label: 'Phone qualified',
              value: '${user.gadget1Qualified}',
            ),
            CustomHorizontalDiver(),
            CustomListSpaceBetwen(
              label: 'Moto qualified',
              value: '${user.gadget2Qualified}',
            ),
            CustomHorizontalDiver(),
            CustomListSpaceBetwen(
              label: 'Car qualified',
              value: '${user.gadget3Qualified}',
            ),
            CustomHorizontalDiver(),
            CustomListSpaceBetwen(
              label: 'PREMIUM',
              value: '${user.novaCashCore}',
            ),
            CustomHorizontalDiver(),
            CustomListSpaceBetwen(
              label: 'P2P-SILVER',
              value: '${user.novaCashP2PSilver}',
            ),
            CustomHorizontalDiver(),
            CustomListSpaceBetwen(
              label: 'P2P-GOLD',
              value: '${user.novaCashP2PGold}',
            ),
            CustomHorizontalDiver(),
            CustomListSpaceBetwen(
              label: 'P2P-RUBY',
              value: '${user.novaCashP2PRuby}',
            ),
            CustomHorizontalDiver(),
          ],
        ),
      ),
    );
  }
}
