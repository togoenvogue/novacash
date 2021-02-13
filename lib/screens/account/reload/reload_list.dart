import 'package:flutter/material.dart';
import '../../../helpers/common.dart';
import '../../../styles/styles.dart';
import 'reload_detail.dart';

class ReloadList extends StatelessWidget {
  final String title;
  final dynamic amount;
  final dynamic amountCrypto;
  final dynamic balanceBefore;
  final dynamic balanceAfter;
  final dynamic timeStamp;
  final String status;
  final String txid;
  final String channel;

  ReloadList({
    this.amount,
    this.amountCrypto,
    this.balanceAfter,
    this.balanceBefore,
    this.title,
    this.timeStamp,
    this.status,
    this.txid,
    this.channel,
  });

  dynamic get statusIcon {
    if (status == 'Pending') {
      return Icons.hourglass_bottom;
    } else if (status == 'OK') {
      return Icons.check_circle;
    } else if (status == 'Failed') {
      return Icons.warning_rounded;
    }
  }

  void _openDetailModal({
    BuildContext ctx,
    String canal,
    dynamic amount,
    dynamic balanceBefore,
    dynamic balanceAfter,
    dynamic crypto,
    String ref,
    int date,
  }) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return ReloadDetail(
          canal: canal,
          cryto: crypto,
          montant: amount,
          balanceAfter: balanceAfter,
          balanceBefore: balanceBefore,
          date: date,
          ref: ref,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _openDetailModal(
            amount: amount,
            canal: channel,
            crypto: amountCrypto,
            ctx: context,
            date: timeStamp,
            balanceAfter: balanceAfter,
            balanceBefore: balanceBefore,
            ref: txid);
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
                  DateHelper().formatTimeStamp(timeStamp),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                child: Container(
                  child: Text(title),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                child: Text(
                  '${NumberHelper().formatNumber(amount).toString()} FCFA',
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
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      ),
    );
  }
}
