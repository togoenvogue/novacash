import 'package:flutter/material.dart';
import '../../../helpers/common.dart';
import '../../../widgets/common/custom_horizontal_diver.dart';
import '../../../widgets/common/custom_list_space_between.dart';

class ReloadDetail extends StatelessWidget {
  final int date;
  final String canal;
  final dynamic montant;
  final dynamic cryto;
  final dynamic balanceBefore;
  final dynamic balanceAfter;
  final String ref;
  ReloadDetail({
    this.canal,
    this.cryto,
    this.date,
    this.montant,
    this.balanceAfter,
    this.balanceBefore,
    this.ref,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Column(
        children: [
          Text(
            canal,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            DateHelper().formatTimeStampFull(date),
            style: TextStyle(
                fontSize: 14, color: Colors.redAccent.withOpacity(0.8)),
            textAlign: TextAlign.center,
          ),
          Text(
            '${NumberHelper().formatNumber(montant).toString()} FCFA',
            style: TextStyle(
              fontSize: 25,
              color: Colors.blue.withOpacity(0.8),
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
          if (cryto != null && cryto > 0)
            Text(
              '${cryto.toString()}',
              style: TextStyle(
                fontSize: 17,
                color: Colors.green.withOpacity(0.8),
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          SizedBox(height: 5),
          CustomListSpaceBetwen(
            label: 'Solde avant',
            value: '${NumberHelper().formatNumber(balanceBefore)} FCFA',
          ),
          CustomHorizontalDiver(),
          CustomListSpaceBetwen(
            label: 'Solde après',
            value: '${NumberHelper().formatNumber(balanceAfter)} FCFA',
          ),
          CustomHorizontalDiver(),
          CustomListSpaceBetwen(
            label: 'Réf',
            value: '$ref',
          ),
        ],
      ),
    );
  }
}
