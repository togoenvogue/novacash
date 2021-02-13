import 'package:flutter/material.dart';

import '../../../styles/styles.dart';
import '../../../helpers/common.dart';
import '../../../models/bonus.dart';

class BonusDetail extends StatelessWidget {
  final BonusModel bonus;
  BonusDetail({this.bonus});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
      child: Column(
        children: [
          Image.asset(
            'assets/images/icon_gain.png',
            height: 50,
          ),
          SizedBox(height: 10),
          Text(
            bonus.type,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            DateHelper().formatTimeStampFull(bonus.timeStamp),
            style: TextStyle(
                fontSize: 14, color: Colors.redAccent.withOpacity(0.8)),
            textAlign: TextAlign.center,
          ),
          Text(
            bonus.fromKey['fullName'],
            style: TextStyle(
              fontSize: 14,
              color: MyColors().primary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5),
          Text(
            bonus.status,
            style: TextStyle(fontSize: 17),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5),
          Text(
            '${NumberHelper().formatNumber(bonus.amount)} FCFA',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
