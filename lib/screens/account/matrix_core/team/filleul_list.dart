import 'package:flutter/material.dart';

import '../../../../models/maxtix_core.dart';
import '../../../../styles/styles.dart';
import '../../../../helpers/common.dart';

class DownlineList extends StatelessWidget {
  final MatrixCoreModel filleul;
  final String userKey;
  DownlineList({this.filleul, this.userKey});
  final _now = DateTime.now().millisecondsSinceEpoch;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      splashColor: MyColors().primary.withOpacity(0.3),
      child: filleul != null
          ? Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 9, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              DateHelper().formatTimeStamp(filleul.timeStamp),
                              style: TextStyle(
                                color: filleul.userKey['expiry'] > _now
                                    ? Colors.white
                                    : Colors.yellow,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              '${filleul.userKey['firstName']} ${filleul.userKey['lastName']}',
                              style: TextStyle(
                                color: filleul.userKey['expiry'] > _now
                                    ? Colors.white
                                    : Colors.yellow,
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
                          vertical: 9, horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: userKey == filleul.sponsorKey['_key'] ||
                                    userKey == filleul.level1['_key'] ||
                                    userKey == filleul.level2['_key'] ||
                                    userKey == filleul.level3['_key'] ||
                                    userKey == filleul.level4['_key'] ||
                                    userKey == filleul.level5['_key'] ||
                                    userKey == filleul.level6['_key'] ||
                                    userKey == filleul.level7['_key'] ||
                                    userKey == filleul.level8['_key'] ||
                                    userKey == filleul.level9['_key'] ||
                                    userKey == filleul.level10['_key'] ||
                                    userKey == filleul.level11['_key'] ||
                                    userKey == filleul.level12['_key'] ||
                                    userKey == filleul.level13['_key'] ||
                                    userKey == filleul.level14['_key'] ||
                                    userKey == filleul.level15['_key'] ||
                                    userKey == filleul.level16['_key'] ||
                                    userKey == filleul.level17['_key'] ||
                                    userKey == filleul.level18['_key'] ||
                                    userKey == filleul.level19['_key'] ||
                                    userKey == filleul.level20['_key']
                                ? SelectableText(
                                    '${filleul.userKey['username']}',
                                    style: TextStyle(
                                      color: filleul.userKey['expiry'] > _now
                                          ? MyColors().primary
                                          : Colors.yellow,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  )
                                : Text(
                                    '${filleul.userKey['username.substring(0, 8)']} ...',
                                    style: TextStyle(
                                      color: filleul.userKey['expiry'] > _now
                                          ? MyColors().primary
                                          : Colors.yellow,
                                      fontWeight: FontWeight.bold,
                                    )),
                          ),
                          Container(
                            child: Text(
                              '${filleul.teamCount} filleuls',
                              style: TextStyle(
                                color: filleul.userKey['expiry'] > _now
                                    ? MyColors().primary
                                    : Colors.yellow,
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
            )
          : Text(''),
    );
  }
}
