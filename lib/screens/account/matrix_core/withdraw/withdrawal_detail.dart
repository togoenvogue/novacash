import 'package:flutter/material.dart';
import '../../../../helpers/common.dart';
import '../../../../widgets/common/custom_horizontal_diver.dart';
import '../../../../widgets/common/custom_list_space_between.dart';
import '../../../../models/withdrawal.dart';

class WithdrawalDetail extends StatelessWidget {
  final WithdrawalModel retrait;
  WithdrawalDetail({this.retrait});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Column(
          children: [
            Text(
              retrait.channel,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              DateHelper().formatTimeStampFull(retrait.timeStamp),
              style: TextStyle(
                  fontSize: 14, color: Colors.redAccent.withOpacity(0.8)),
              textAlign: TextAlign.center,
            ),
            CustomListSpaceBetwen(
              label: 'A recevoir',
              value: '${NumberHelper().formatNumber(retrait.amount)} FCFA',
            ),
            if (retrait.channel == 'Mobile') CustomHorizontalDiver(),
            if (retrait.channel == 'Mobile')
              CustomListSpaceBetwen(
                label: 'Téléphone',
                value: '+${retrait.countryCode}${retrait.account}',
              ),
            if (retrait.channel == 'Ria' ||
                retrait.channel == 'MoneyGram' ||
                retrait.channel == 'WesternUnion')
              CustomHorizontalDiver(),
            if (retrait.channel == 'Ria' ||
                retrait.channel == 'MoneyGram' ||
                retrait.channel == 'WesternUnion')
              CustomListSpaceBetwen(
                label: 'Nom',
                value: '${retrait.lastName}',
              ),
            if (retrait.channel == 'Ria' ||
                retrait.channel == 'MoneyGram' ||
                retrait.channel == 'WesternUnion')
              CustomHorizontalDiver(),
            if (retrait.channel == 'Ria' ||
                retrait.channel == 'MoneyGram' ||
                retrait.channel == 'WesternUnion')
              CustomListSpaceBetwen(
                label: 'Prénom(s)',
                value: '${retrait.firstName}',
              ),
            if (retrait.channel == 'Ria' ||
                retrait.channel == 'MoneyGram' ||
                retrait.channel == 'WesternUnion')
              CustomHorizontalDiver(),
            if (retrait.channel == 'Ria' ||
                retrait.channel == 'MoneyGram' ||
                retrait.channel == 'WesternUnion')
              CustomListSpaceBetwen(
                label: 'Ville',
                value: '${retrait.city}',
              ),
            if (retrait.channel == 'Ria' ||
                retrait.channel == 'MoneyGram' ||
                retrait.channel == 'WesternUnion')
              CustomHorizontalDiver(),
            if (retrait.channel == 'Ria' ||
                retrait.channel == 'MoneyGram' ||
                retrait.channel == 'WesternUnion')
              CustomListSpaceBetwen(
                label: 'Pays',
                value: '${retrait.country}',
              ),
            if (retrait.txid != null &&
                retrait.status != 'Pending' &&
                retrait.channel != 'Bitcoin' &&
                retrait.channel != 'Ethereum')
              CustomHorizontalDiver(),
            if (retrait.txid != null &&
                retrait.status != 'Pending' &&
                retrait.channel != 'Bitcoin' &&
                retrait.channel != 'Ethereum')
              CustomListSpaceBetwen(
                label: 'REF/TXID/MTCN',
                value: '${retrait.txid}',
              ),
            if (retrait.status == 'Pending') CustomHorizontalDiver(),
            if (retrait.status == 'Pending')
              CustomListSpaceBetwen(
                label: 'Statut',
                value: 'Traitement en cours',
              ),
            if (retrait.status != 'Pending') CustomHorizontalDiver(),
            if (retrait.status != 'Pending')
              CustomListSpaceBetwen(
                label: 'Statut',
                value: 'Paiement traité',
              ),
            if (retrait.txid != null &&
                    retrait.status != 'Pending' &&
                    retrait.channel == 'Bitcoin' ||
                retrait.txid != null &&
                    retrait.status != 'Pending' &&
                    retrait.channel == 'Ethereum')
              CustomHorizontalDiver(),
            if (retrait.txid != null &&
                    retrait.status != 'Pending' &&
                    retrait.channel == 'Bitcoin' ||
                retrait.txid != null &&
                    retrait.status != 'Pending' &&
                    retrait.channel == 'Ethereum')
              SizedBox(height: 10),
            if (retrait.txid != null &&
                    retrait.status != 'Pending' &&
                    retrait.channel == 'Bitcoin' ||
                retrait.txid != null &&
                    retrait.status != 'Pending' &&
                    retrait.channel == 'Ethereum')
              Text('ADRESSE'),
            if (retrait.txid != null &&
                    retrait.status != 'Pending' &&
                    retrait.channel == 'Bitcoin' ||
                retrait.txid != null &&
                    retrait.status != 'Pending' &&
                    retrait.channel == 'Ethereum')
              Text(
                retrait.account,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            if (retrait.txid != null &&
                    retrait.status != 'Pending' &&
                    retrait.channel == 'Bitcoin' ||
                retrait.txid != null &&
                    retrait.status != 'Pending' &&
                    retrait.channel == 'Ethereum')
              SizedBox(height: 20),
            if (retrait.txid != null &&
                    retrait.status != 'Pending' &&
                    retrait.channel == 'Bitcoin' ||
                retrait.txid != null &&
                    retrait.status != 'Pending' &&
                    retrait.channel == 'Ethereum')
              Text('TXID'),
            if (retrait.txid != null &&
                    retrait.status != 'Pending' &&
                    retrait.channel == 'Bitcoin' ||
                retrait.txid != null &&
                    retrait.status != 'Pending' &&
                    retrait.channel == 'Ethereum')
              SelectableText(
                retrait.txid,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            if (retrait.txid != null &&
                retrait.status != 'Pending' &&
                retrait.channel != 'Bitcoin' &&
                retrait.channel != 'Ethereum')
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                color: Colors.green.withOpacity(0.4),
                width: double.infinity,
                child: Text(
                  '${retrait.mobileMoney}',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
