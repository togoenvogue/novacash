import 'package:flutter/material.dart';

import '../../../screens/account/withdraw/withdrawal_detail.dart';
import '../../../helpers/common.dart';
import '../../../models/withdrawal.dart';
import '../../../styles/styles.dart';

class WithdrawalsList extends StatelessWidget {
  final WithdrawalModel obj;

  WithdrawalsList({this.obj});

  void _openDetailModal({BuildContext ctx, WithdrawalModel retrait}) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return WithdrawalDetail(retrait: retrait);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _openDetailModal(ctx: context, retrait: obj);
      },
      splashColor: MyColors().primary.withOpacity(0.3),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        obj.channel,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    obj != null && obj.account != null
                        ? Container(
                            child: obj.account != "null"
                                ? Text(
                                    obj.account.length <= 20
                                        ? obj.account
                                        : '${obj.account.substring(0, 20)} [...]',
                                    style: TextStyle(
                                      color: obj.status == 'Pending'
                                          ? Colors.yellow
                                          : Colors.greenAccent,
                                    ),
                                  )
                                : Text(
                                    '${obj.city} - ${obj.country}',
                                    style: TextStyle(
                                      color: obj.status == 'Pending'
                                          ? Colors.yellow
                                          : Colors.greenAccent,
                                    ),
                                  ),
                          )
                        : Container(
                            child: Text(''),
                          ),
                  ],
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        '${NumberHelper().formatNumber(obj.amount).toString()} F',
                        style: TextStyle(
                          color: MyColors().primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        DateHelper().formatTimeStamp(obj.timeStamp),
                        style: TextStyle(
                          color: MyColors().primary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
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
