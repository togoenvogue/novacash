import 'package:flutter/material.dart';

import '../../../../helpers/common.dart';
import '../../../../widgets/common/custom_horizontal_diver.dart';
import '../../../../widgets/common/custom_list_space_between.dart';
import '../../../../models/transfer.dart';

class TransfertDetail extends StatelessWidget {
  final TransferModel transfer;
  final String userKey;
  TransfertDetail({this.transfer, this.userKey});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Column(
        children: [
          Text(
            '${NumberHelper().formatNumber(transfer.amount)} FCFA',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            DateHelper().formatTimeStampFull(transfer.timeStamp),
            style: TextStyle(
                fontSize: 14, color: Colors.redAccent.withOpacity(0.8)),
            textAlign: TextAlign.center,
          ),
          CustomListSpaceBetwen(
            label: 'Solde avant',
            value:
                '${transfer.fromKey['_key'] == userKey ? NumberHelper().formatNumber(transfer.senderBalanceBefore) : NumberHelper().formatNumber(transfer.benefBalanceAfter)} FCFA',
          ),
          CustomHorizontalDiver(),
          CustomListSpaceBetwen(
            label: 'Montant du transfert',
            value: '${NumberHelper().formatNumber(transfer.amount)} FCFA',
          ),
          CustomHorizontalDiver(),
          CustomListSpaceBetwen(
            label: 'Solde après',
            value:
                '${transfer.fromKey['_key'] == userKey ? NumberHelper().formatNumber(transfer.senderBalanceAfter) : NumberHelper().formatNumber(transfer.benefBalanceAfter)} FCFA',
          ),
          CustomHorizontalDiver(),
          CustomListSpaceBetwen(
            label: 'Exp.',
            value:
                '${transfer.fromKey['firstName']} ${transfer.fromKey['lastName']}',
          ),
          CustomHorizontalDiver(),
          CustomListSpaceBetwen(
            label: 'Bénéf.',
            value:
                '${transfer.toKey['firstName']} ${transfer.toKey['lastName']}',
          ),
        ],
      ),
    );
  }
}
