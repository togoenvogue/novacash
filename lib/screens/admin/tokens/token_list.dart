import 'package:flutter/material.dart';
import '../../../models/token.dart';
import '../../../helpers/common.dart';
import '../../../styles/styles.dart';
import 'token_detail.dart';

class TokenList extends StatelessWidget {
  final TokenModel token;

  TokenList({this.token});

  void _openDetailModal({BuildContext ctx, TokenModel token}) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return TokenDetail(token: token);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return token != null
        ? InkWell(
            onTap: () {
              _openDetailModal(ctx: context, token: token);
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
                          vertical: 8, horizontal: 6),
                      child: Text(
                        '${DateHelper().formatTimeStamp(token.timeStamp)}',
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
                          '${token.token}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 9, horizontal: 8),
                      child: Text(
                        '${NumberHelper().formatNumber(token.amount).toString()}',
                        style: TextStyle(
                          color: Colors.yellow,
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
