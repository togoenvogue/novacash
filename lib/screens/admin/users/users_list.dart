import 'package:flutter/material.dart';

import '../../../screens/admin/users/users_detail.dart';
import '../../../styles/styles.dart';
import '../../../models/user.dart';
import '../../../helpers/common.dart';

class AdminUsersList extends StatelessWidget {
  final UserModel filleul;
  final String userKey;
  AdminUsersList({this.filleul, this.userKey});

  void _openDetailModal({BuildContext ctx, UserModel user}) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return AdminUserDetail(user: user);
      },
    );
  }

  final _now = DateTime.now().millisecondsSinceEpoch;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _openDetailModal(ctx: context, user: filleul);
      },
      splashColor: MyColors().primary.withOpacity(0.3),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        DateHelper().formatTimeStamp(filleul.timeStamp),
                        style: TextStyle(
                          color: filleul.expiry > _now
                              ? Colors.white
                              : Colors.yellow,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        '${filleul.firstName} ${filleul.lastName}',
                        style: TextStyle(
                          color: filleul.expiry > _now
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
                padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: SelectableText(
                        '${filleul.username}',
                        style: TextStyle(
                          color: filleul.expiry > _now
                              ? MyColors().primary
                              : Colors.yellow,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Container(
                      child: SelectableText(
                        '${filleul.isSupport == true ? NumberHelper().formatNumber(filleul.credits_balance) : NumberHelper().formatNumber(filleul.ewallet_balance)} F',
                        style: TextStyle(
                          color: filleul.isSupport == true
                              ? Colors.yellow
                              : Colors.white,
                          fontWeight: FontWeight.normal,
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
    );
  }
}
