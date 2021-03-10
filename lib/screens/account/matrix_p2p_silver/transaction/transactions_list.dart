import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';

import '../../../../screens/account/matrix_p2p_silver/transaction/approve.dart';
import '../../../../screens/account/matrix_p2p_silver/transaction/notify.dart';
import '../../../../models/p2p_transaction.dart';
import '../../../../helpers/common.dart';
import '../../../../styles/styles.dart';
import 'transaction_detail.dart';

class P2PSilverTransactionsList extends StatefulWidget {
  final P2PTransactionModel obj;
  final String userKey;

  P2PSilverTransactionsList({this.obj, this.userKey});

  @override
  _P2PSilverTransactionsListState createState() =>
      _P2PSilverTransactionsListState();
}

class _P2PSilverTransactionsListState extends State<P2PSilverTransactionsList> {
  void _openDetailModal({BuildContext ctx, P2PTransactionModel transaction}) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return P2PSilverTransactionDetail(
          data: transaction,
          userKey: widget.userKey,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.obj.status == 'Pending' &&
            widget.obj.fromKey['_key'] == widget.userKey) {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
            CubePageRoute(
              enterPage: P2PTransactionNotifyScreen(don: widget.obj),
              exitPage: P2PTransactionNotifyScreen(don: widget.obj),
              duration: const Duration(milliseconds: 300),
            ),
          );
        } else if (widget.obj.status == 'Waiting' &&
            widget.obj.toKey['_key'] == widget.userKey) {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
            CubePageRoute(
              enterPage: P2PTransactionApproveScreen(don: widget.obj),
              exitPage: P2PTransactionApproveScreen(don: widget.obj),
              duration: const Duration(milliseconds: 300),
            ),
          );
        } else {
          _openDetailModal(ctx: context, transaction: widget.obj);
        }
      },
      splashColor: MyColors().primary.withOpacity(0.3),
      child: widget.obj != null
          ? Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 9, horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              widget.obj.toChannel != null
                                  ? widget.obj.toChannel
                                  : '',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          widget.obj != null && widget.obj.toAccount != null
                              ? Container(
                                  child: widget.obj.toAccount != "null"
                                      ? Text(
                                          widget.obj.toAccount.length <= 20
                                              ? widget.obj.toAccount
                                              : '${widget.obj.toAccount.substring(0, 15)} [...]',
                                          style: TextStyle(
                                            color:
                                                widget.obj.status == 'Pending'
                                                    ? Colors.yellow
                                                    : Colors.greenAccent,
                                          ),
                                        )
                                      : Text(
                                          '${widget.obj.toKey['city']}',
                                          style: TextStyle(
                                            color:
                                                widget.obj.status == 'Pending'
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 9, horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              '${NumberHelper().formatNumber(widget.obj.amountXOF).toString()} F',
                              style: TextStyle(
                                color: MyColors().primary,
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              DateHelper()
                                  .formatTimeStamp(widget.obj.timeStamp),
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
            )
          : Text('...'),
    );
  }
}
