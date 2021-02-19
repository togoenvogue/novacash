import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../widgets/common/custom_alert.dart';
import '../../../helpers/common.dart';
import '../../../widgets/common/custom_horizontal_diver.dart';
import '../../../widgets/common/custom_list_space_between.dart';
import '../../../models/token.dart';

class TokenDetail extends StatelessWidget {
  final TokenModel token;
  TokenDetail({this.token});

  @override
  Widget build(BuildContext context) {
    /*
    void _showToast(BuildContext context) {
      final scaffold = Scaffold.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: const Text('Updating..'),
        ),
      );
    }*/

    void _copy({String code}) {
      Clipboard.setData(
        ClipboardData(text: code),
      );
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Copié!',
        'Le code $code a été copé. Vous pouvez le partager',
        true,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Column(
        children: [
          Text('Cliquez sur le code pour le copier'),
          SizedBox(height: 10),
          InkWell(
            onTap: () async {
              _copy(code: token.token);
            },
            child: Text(
              '${token.token}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Text(
            DateHelper().formatTimeStampFull(token.timeStamp),
            style: TextStyle(
                fontSize: 14, color: Colors.redAccent.withOpacity(0.8)),
            textAlign: TextAlign.center,
          ),
          CustomListSpaceBetwen(
            label: 'Solde du code',
            value: '${NumberHelper().formatNumber(token.amount)} FCFA',
          ),
          CustomListSpaceBetwen(
            label: 'Votre solde avant',
            value:
                '${NumberHelper().formatNumber(token.userBalanceBefore)} FCFA',
          ),
          CustomListSpaceBetwen(
            label: 'Votre solde après',
            value:
                '${NumberHelper().formatNumber(token.userBalanceAfter)} FCFA',
          ),
          CustomHorizontalDiver(),
          if (token.userKey != null && token.userKey['firstName'] != null)
            CustomListSpaceBetwen(
              label: 'Utilisé par',
              value:
                  '${token.userKey['firstName']} ${token.userKey['lastName']}',
            ),
          if (token.userKey != null && token.userKey['firstName'] != null)
            CustomListSpaceBetwen(
              label: 'Téléphone',
              value: '+${token.userKey['username']}',
            ),
          if (token.userKey != null && token.userKey['firstName'] != null)
            CustomListSpaceBetwen(
              label: 'Date',
              value: '${DateHelper().formatTimeStampFull(token.usageStamp)}',
            ),
          if (token.userKey == null)
            CustomListSpaceBetwen(
              label: 'Statut',
              value: 'Code non utilisé',
            ),
        ],
      ),
    );
  }
}
