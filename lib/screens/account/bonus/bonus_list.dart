import 'package:flutter/material.dart';
import '../../../models/bonus.dart';
import '../../../helpers/common.dart';
import '../../../styles/styles.dart';
import 'bonus_detail.dart';

class BonusList extends StatelessWidget {
  final BonusModel bonus;
  BonusList({this.bonus});

  void _openDetailModal({BuildContext ctx, BonusModel bonus}) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return BonusDetail(bonus: bonus);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _openDetailModal(bonus: bonus, ctx: context);
      },
      splashColor: MyColors().primary.withOpacity(0.3),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                child: Text(
                  DateHelper().formatTimeStamp(bonus.timeStamp),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                child: Container(
                  child: Text(bonus.type),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                child: Text(
                  '${NumberHelper().formatNumber(bonus.amount).toString()} F',
                  style: TextStyle(
                    color: MyColors().primary,
                  ),
                ),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: MyColors().primary.withOpacity(0.2),
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      ),
    );
  }
}
