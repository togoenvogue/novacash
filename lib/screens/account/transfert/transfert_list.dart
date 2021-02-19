import 'package:flutter/material.dart';
import '../../../helpers/common.dart';
import '../../../styles/styles.dart';
import '../../../models/transfer.dart';
import 'transfert_detail.dart';

class TransfertList extends StatelessWidget {
  final TransferModel transfer;
  final String userKey;

  TransfertList({this.transfer, this.userKey});

  void _openDetailModal({BuildContext ctx, TransferModel transfert}) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return TransfertDetail(transfer: transfert, userKey: userKey);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return transfer != null
        ? InkWell(
            onTap: () {
              _openDetailModal(ctx: context, transfert: transfer);
            },
            splashColor: MyColors().primary.withOpacity(0.3),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 9, horizontal: 8),
                      child: Text(
                        '${DateHelper().formatTimeStamp(transfer.timeStamp)}',
                        style: TextStyle(
                          color: Colors.greenAccent[100],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 9, horizontal: 8),
                      child: Container(
                        child: Text(
                          '${transfer.fromKey['_key'] == userKey ? 'Transfert envoyé' : 'Transfert reçu'}',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 9, horizontal: 8),
                      child: transfer.fromKey['_key'] == userKey
                          ? Text(
                              '-${NumberHelper().formatNumber(transfer.amount).toString()} F',
                              style: TextStyle(
                                color: Colors.yellow,
                              ),
                            )
                          : Text(
                              '+${NumberHelper().formatNumber(transfer.amount).toString()} F',
                              style: TextStyle(
                                color: MyColors().success,
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
          )
        : Text('... chargement');
  }
}
