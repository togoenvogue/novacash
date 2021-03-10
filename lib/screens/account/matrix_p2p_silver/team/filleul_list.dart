import 'package:flutter/material.dart';

import '../../../../models/matrix_p2p.dart';
import '../../../../styles/styles.dart';
import '../../../../helpers/common.dart';

class P2PSilverDownlineList extends StatelessWidget {
  final MatrixP2PModel filleul;
  final String userKey;
  P2PSilverDownlineList({this.filleul, this.userKey});
  @override
  Widget build(BuildContext context) {
    return filleul != null
        ? InkWell(
            onTap: () {},
            splashColor: MyColors().primary.withOpacity(0.3),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 9,
                        horizontal: 0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              DateHelper().formatTimeStamp(filleul.timeStamp),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              '${filleul.userKey['firstName']} ${filleul.userKey['lastName']}',
                              style: TextStyle(
                                color: userKey == filleul.linkedTo['_key']
                                    ? Color(0xffabf786)
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 9,
                        horizontal: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: userKey == filleul.sponsorKey['_key'] ||
                                    userKey == filleul.linkedTo['_key']
                                ? SelectableText(
                                    '${filleul.userKey['username']}',
                                    style: TextStyle(
                                      color: MyColors().primary,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  )
                                : Text(
                                    '${filleul.userKey['username.substring(0, 8)']} ...',
                                    style: TextStyle(
                                      color: MyColors().primary,
                                      fontWeight: FontWeight.bold,
                                    )),
                          ),
                          Container(
                            child: Text(
                              '${filleul.level1Count + filleul.level2Count} filleuls',
                              style: TextStyle(
                                color: MyColors().primary,
                                fontSize: 13,
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
                    color: MyColors().primary.withOpacity(0.1),
                  ),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            ),
          )
        : Text('');
  }
}
