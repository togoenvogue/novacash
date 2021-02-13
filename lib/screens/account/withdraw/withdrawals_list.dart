import 'package:flutter/material.dart';

import '../../../helpers/common.dart';
import '../../../models/withdrawal.dart';
import '../../../styles/styles.dart';

class WithdrawalsList extends StatelessWidget {
  final WithdrawalModel obj;

  WithdrawalsList({this.obj});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      splashColor: MyColors().primary.withOpacity(0.3),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        DateHelper().formatTimeStamp(obj.timeStamp),
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    obj != null && obj.txid != null
                        ? Container(
                            child: Text(
                              obj.txid.length <= 11
                                  ? obj.txid
                                  : obj.txid.substring(0, 11),
                              style: TextStyle(
                                color: MyColors().info,
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(obj.channel),
                    ),
                    obj != null && obj.account != null
                        ? Container(
                            child: Text(
                              obj.account.length <= 11
                                  ? obj.account
                                  : obj.account.substring(0, 11),
                              style: TextStyle(
                                color: MyColors().danger,
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
                        '${NumberHelper().formatNumber(obj.amount).toString()} FCFA',
                        style: TextStyle(
                          color: MyColors().primary,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        'Tous frais déduits',
                        style: TextStyle(
                          color: MyColors().normal.withOpacity(0.8),
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
