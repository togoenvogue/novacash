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
            'assets/images/icon-bonus.png',
            height: 70,
          ),
          SizedBox(height: 10),
          Text(
            'Bonus: ${bonus.type}',
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
            '${bonus.fromKey['firstName']} ${bonus.fromKey['lastName']}',
            style: TextStyle(
              fontSize: 14,
              color: MyColors().info,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5),
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 40,
          ),
          SizedBox(height: 5),
          Text(
            '${NumberHelper().formatNumber(bonus.amount)} FCFA',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
